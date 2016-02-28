class Book < ActiveRecord::Base

  #after_initialize {
  #TODO optimize books
  #}

  def getSearchIndex(search_req)
    search_eq = self.search_index.to_i
    #TODO calculated books index
    return search_eq
  end

  def eq_text(find_w, source)
    arr_f = find_w.to_s.split(' ')
    arr_s = source.to_s.split(' ')
    indexs = []
    arr_f.each do |word|
      indexs_tmp = []
      arr_s.each { |word_s| indexs_tmp.push eq_word word, word_s }
      indexs.push indexs_tmp
    end
    #TODO rewrite shitcode
  end

  def eq_word(word, word_source)
    #TODO calculated word eq
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
    else self.author end
  end

  def getAnnotation
    if self.annotation.nil?
      'Аннотация отсутсвует'
    else self.annotation end
  end

  def getName
    if self.name.nil?
      'Неизвестная книга'
    else self.name end
  end

end
