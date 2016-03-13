class ApiController < ApplicationController
  require 'digest/md5'
  include BCrypt
  #Digest::MD5.hexdigest("Hello from Dmitry")
  @@auth_token_arr = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

  def self.version
    return '0.1e ALPHA'
  end

  def register
    begin
      if params[:pswd].nil? || params[:login].nil?
        raise 'Need password or login!'
      end
      if User.all.length == 0
        User.create(login: params[:login], pswd: Password.create(params[:pswd]), perm: 100)
        render text: '1: Register successful as admin'
      else
        User.create(login: params[:login], pswd: Password.create(params[:pswd]), perm: 10)
        render text: '2: Register successful as user'
      end
    rescue RuntimeError => e
      render text: "-1: Register error. Msg: #{e.message}"
    end
  end

  def login
    begin
      if params[:pswd].nil? || params[:login].nil?
        raise 'Need password or login!'
      end
      usr = User.find_by_login params[:login]
      if Password.new(usr.pswd) == params[:pswd]
        auth_token = AuthToken.new
        auth_tokenNum=(0...64).map { @@auth_token_arr[rand(@@auth_token_arr.length)] }.join
        while !(AuthToken.find_by_auth_token auth_tokenNum).nil?
          auth_tokenNum=(0...64).map { @@auth_token_arr[rand(@@auth_token_arr.length)] }.join
        end
        auth_token.auth_token=auth_tokenNum
        auth_token.typeToken=params[:type].nil? ? 0 : 10
        auth_token.user_id=usr.id
        auth_token.perm=usr.perm
        auth_token.save!
        render text: auth_token.auth_token
      else
        render text: '0: Login or password invalid'
      end
    rescue RuntimeError => e
      render text: "-1: Auth error. Msg: #{e.message}"
    end
  end

  def api
    begin
      token = AuthToken.find_by_auth_token params[:token]
      if token.nil?
        raise 'Auth Token invalid'
      end
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
      else
        render text: "Last request: #{token.last_req}"
      end
    rescue RuntimeError => e
      render text: "-1: Api request error. Msg: #{e.message}"
    end
  end

  def checkParams(params, *param)
    param.each { |p|
      if params[p].nil?
        raise "Params '#{p}' is nil"
      end }
  end

  private

  def addBook(token, params)
    begin
      if token.perm < 25
        raise 'Permission error'
      end
      checkParams params, :name, :author
      b = Book.create name: params[:name], author: params[:author], annotation: params[:annotation], table_of_contents: params[:table_of_contents], user_add: token.user_id
      render text: b.id.to_s
    rescue RuntimeError => e
      render text: "Error add book. Msg: #{e.message}"
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
      render text: "Error add book. Msg: #{e.message}"
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
      render text: "Error add book. Msg: #{e.message}"
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
      render text: "Error add book. Msg: #{e.message}"
    end
  end
end
