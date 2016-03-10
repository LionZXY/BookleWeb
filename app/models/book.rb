class Book < ActiveRecord::Base
  require 'search'
  require 'rubygems'

  #after_initialize {
  #TODO optimize books
  #}

  def getSearchIndex(search_req)
    search_eq = 0.0
   #search_eq += self.search_index.to_i
    search_eq += (Search.new.eq_text(search_req, getName)/getName.length)
    search_eq += ((Search.new.eq_text search_req, getAuthor)/getAuthor.length)
    search_eq += ((Search.new.eq_text search_req, getAnnotation)/getAnnotation.length) / 2

    return search_eq
  end

  validates :name, presence: true
  validates :author, presence: true

  def to_s
    if author.nil?
      self.author = 'Неизвестный автор'
    end
    if name.nil?
      self.name = 'Неизвестная книга'
    end
    return "#{self.author}: #{self.name} "
  end

  def getAuthor
    if self.author.nil?
      'Неизвестный автор'
    else
      self.author
    end
  end

  def getAnnotation
    if self.annotation.nil?
      'Аннотация отсутсвует'
    else
      self.annotation
    end
  end

  def getName
    if self.name.nil?
      'Неизвестная книга'
    else
      self.name
    end
  end
end
