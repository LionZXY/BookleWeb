class ApiController < ApplicationController
  require 'digest/md5'
  include BCrypt
  #Digest::MD5.hexdigest("Hello from Dmitry")
  skip_before_action :verify_authenticity_token

  def self.version
    return '0.1g ALPHA'
  end

  def self.user(params)
    token = AuthToken.find_by_auth_token (params[:token].nil? ? nil : params[:token].to_i(16))
    return (token.nil? ? nil : (User.find_by_id token.user_id))
  end

  def userInfo
    render 'books/user'
  end

  def self.getNameByCookie(cookie)
    return ApiController.getNameByUser (ApiController.user(cookie))
  end

  def register
    begin
      if params[:pswd].nil? || params[:login].nil?
        render json: {err_code: 1, text: 'Один из необходимых параметров пустой'}
      else
        if User.all.length == 0
          User.create(login: params[:login], pswd: Password.create(params[:pswd]), name: params[:name], perm: 100)
          render json: {text: 'Вы зарегестрированный как администратор'}
        elsif (User.find_by_login params[:login]).nil?
          User.create(login: params[:login], pswd: Password.create(params[:pswd]), name: params[:name], perm: 10)
          render json: {text: 'Вы зарегестрированны', login: params[:login]}
        else
          render json: {text: 'Вы уже зарегестрированны', login: params[:login]}
        end
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end


  def login
    begin
      if params[:pswd].nil? || params[:login].nil?
        render json: {err_code: 1, text: 'Один из необходимых параметров пустой'}
      else
        usr = User.find_by_login params[:login]
        if !usr.nil? && Password.new(usr.pswd) == params[:pswd]
          auth_token = AuthToken.new
          auth_tokenNum=rand(9223372036854775806)
          until (AuthToken.find_by_auth_token auth_tokenNum).nil?
            auth_tokenNum=rand(9223372036854775806)
          end
          auth_token.auth_token=auth_tokenNum
          auth_token.typeToken=params[:type].nil? ? 0 : params[:type]
          auth_token.user_id=usr.id
          auth_token.uniq_id=rand(100000)
          auth_token.perm=usr.perm
          auth_token.save!
          cookies[:auth_token] = auth_token
          render json: {token: auth_token.auth_token.to_s(16), uniq_id: auth_token.uniq_id, id: auth_token.id}
        else
          render json: {err_code: 2, text: 'Такой комбинации логин/пароль не существует'}
        end
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

  def check
    begin
      if params[:id].nil?
        if params[:token].nil?
          render text: 0
        else
          render text: !((AuthToken.find_by_auth_token params[:token]).nil?)
        end
      else
        token = AuthToken.find_by_id params[:id]
        if token.nil?
          render json: {err_code: 2, text: 'Token id is null or unfind'}
        else
          render json: {uniq_id: token.uniq_id}
        end
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end


  def api
    begin
      if params[:token].nil?
        render json: {err_code: 1, text: 'Один из необходимых параметров пустой'}
      else
        token = AuthToken.find_by_auth_token params[:token].to_i(16)
        if token.nil? && !cookies[:token].nil?
          token = AuthToken.find_by_auth_token cookies[:token].to_i(16)
        end

        if token.nil?
          render json: {err_code: 1, text: 'Один из необходимых параметров пустой или токен не валидный'}
        else
          token.update! last_req: Time.now
          #user = User.find_by_id(token.user_id)
          if params[:method] == 'addBook'
            addBook token, params
          elsif params[:method] == 'removeBook'
            removeBook token, params
          elsif params[:method] == 'info'
            info token, params
          elsif params[:method] == 'search'
            searchBook token, params
          elsif params[:method] == 'name'
            getName token
          elsif params[:method] == 'destroy'
            render text: '1'
            token.destroy!
          else
            render text: "Last request: #{token.last_req}"
          end
        end
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

  def checkParams(params, *param)
    param.each { |p|
      if params[p].nil?
        raise "Params '#{p}' is nil"
      end }
  end

  def self.getNameByUser(user)
    if user.nil?
      return nil
    end
    name = user.name
    if (name.nil? || name.length < 2)
      name = user.login
    end
    return name
  end

  private

  def getName(token)
    user = User.find_by_id token.user_id
    if (user.nil?)
      render json: {err_code: 1, text: 'Неверный токен'}
    else
      render json: {text: ApiController.getNameByUser(user)}
    end
  end

  def addBook(token, params)
    begin
      if token.perm < 25
        raise 'Permission error'
      end
      checkParams params, :name, :author
      b = Book.create name: params[:name], author: params[:author], annotation: params[:annotation], table_of_contents: params[:table_of_contents], user_add: token.user_id
      render text: b.id.to_s
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

  def removeBook(token, params)
    begin
      if token.perm < 30
        raise 'Permission error'
      end
      checkParams params, :book_id
      Book.find_by_id(parms[:book_id]).destroy!
      render text: "Book with id #{params[:book_id]} was removed"
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

  def info(token, params)
    begin
      if token.perm < 5
        raise 'Permission error'
      end
      if params[:book_id].nil?
        render json: Book.all
      else
        render json: Book.find_by_id(params[:book_id])
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

  def searchBook(token, params)
    begin
      if token.perm < 5
        raise 'Permission error'
      end
      if params[:srch].nil?
        render json: Book.all
      else
        render json: Book.all.to_a.sort { |book1, book2| book2.getSearchIndex(params[:srch]) - book1.getSearchIndex(params[:srch]) }
      end
    rescue RuntimeError => e
      render json: {err_code: -1, text: e.message}
    end
  end

end
