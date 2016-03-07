class BooksController < ApplicationController
  @@req_par = [:name, :author]

  def index
    @books = Book.all
    @books.map do |b|
      print 'Name '
      puts b.name
    end

    render 'books/index'
  end

  def info
    @this_book = Book.find_by id: params[:bookid]
    render 'books/info'
  end

  def about_us
    render 'books/about_us'
  end
  def search

    p params
    if params[:srch].nil?
      render text: 'Отсутсвует необходимый параметр: srch'
    else
      @books = Book.all
      @books = @books.to_a.sort { |book1, book2| book1.getSearchIndex(params[:srch]) - book2.getSearchIndex(params[:srch]) }
      @books_for_s = []
      @books.each do |i|
        @books_for_s.push i
      end
      render 'books/search'
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
