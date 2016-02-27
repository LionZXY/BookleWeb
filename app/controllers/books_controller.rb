class BooksController < ApplicationController
  @@req_par = [:name, :author]

  def index
    @books = Book.all
    @books.map do |b|
      print 'Name '
      puts b.name
    end

    render text: @books.map { |b| "#{b[:name]}: #{b[:author]} <br>" }
  end

  def search
    p params
    if params[:srch].nil?
      render text: 'Отсутсвует необходимый параметр: srch'
    else
      @books = Book.all
      @books = @books.to_a.sort { |book1, book2| book2.getSearchIndex(params[:srch]) - book1.getSearchIndex(params[:srch]) }
      exit_s = ''
      @books.each do |i|
        exit_s += i.to_s
        exit_s += '<br>'
      end
      render text: exit_s
      puts 'Search result:'
      p @books
    end
  end

  def addBook
    begin
      valPar params
      b = Book.create name: params[:name], author: params[:author]
      render text: b.id.to_s
    rescue RuntimeError => e
      render text: "Error add book. Msg: #{e.message}"
    end
  end

  def valPar(params)
    @@req_par.each do
    |i|
      if params[i].nil?
        raise "Params #{i} is nil"
      end
    end
  end
end
