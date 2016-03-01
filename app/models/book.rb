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
    #TODO rewrite shitcode
    words_arr = find_w.to_s.split ' '
    words_s_arr = source.to_s.split ' '
    n = words_arr.length
    m = words_s_arr.length

    return m if (0 == n)
    return n if (0 == m)

    d = (0..m).to_a
    x = nil

    words_arr.each_with_index do |word1, i|
      e = i + 1

      words_s_arr.each_with_index do |word2, j|
        x = [
            #d[j + 1] +
        ]
      end

    end
    distance("Something", "Smoething")
  end

  def self.distance str1, str2
    #This code from https://github.com/GlobalNamesArchitecture/damerau-levenshtein
    n = str1.length
    m = str2.length

    return m if (0 == n)
    return n if (0 == m)

    #Храним лишь одномерный массив.
    d = (0..m).to_a
    x = nil

    str1.each_char.each_with_index do |char1, i|
      e = i+1

      str2.each_char.each_with_index do |char2, j|
        cost = (char1 == char2) ? 0 : 1
        x = [
            d[j+1] + 1, # insertion
            e + 1, # deletion
            d[j] + cost # substitution
        ].min
        d[j] = e
        e = x
      end

      d[m] = x
    end

    return x
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
