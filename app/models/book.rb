class Book < ActiveRecord::Base

  #after_initialize {
  #TODO optimize search
  #}

  def getSearchIndex(search_req)
    search_eq = self.search_index.to_i
    #TODO calculated search index
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

end
