module SearchUtils
  class << self
    def soundex(string)
      copy = string.upcase.tr '^A-Z', ''
      return nil if copy.empty?
      first_letter = copy[0, 1]
      copy.tr_s! 'AEHIOUWYBFPVCGJKQSXZDTLMNR', '00000000111122222222334556'
      copy.sub!(/^(.)\1*/, '').gsub!(/0/, '')
      "#{first_letter}#{copy.ljust(3,"0")}"
    end

    def remove_stopwords(words)
      words.reject do |word|
        ["a", "an", "and", "or", "but", "the", "of", "to", "at", "as", "by"].include?(word.downcase)
      end
    end

    def to_wordlist(string)
      string.gsub(/[^0-9a-zA-Z\s]/, '').split(/\s+/)
    end

    def searchable_string(string)
      self.remove_stopwords(self.to_wordlist(string)).join(' ').strip
    end
  end
end
