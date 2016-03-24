class BooksController < ApplicationController
  @@req_par = [:name, :author]

  def index
    @books = Book.all
    @books.map do |b|
      print 'Name '
      puts b.name
    end

    cookies[:user_name] = 'Nikita'
    puts cookies[:user_name]
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
      @books = @books.to_a.sort { |book1, book2| book2.getSearchIndex(params[:srch]) - book1.getSearchIndex(params[:srch]) }
      @books_for_s = []
      @books.each do |i|
        @books_for_s.push i
      end
      render 'books/search'
    end
  end

end
