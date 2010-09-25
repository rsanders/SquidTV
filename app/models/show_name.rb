require_dependency 'search_utils'

class ShowName < ActiveRecord::Base
  belongs_to :show

  PROCESS_EXACT = "exact"
  PROCESS_SOUNDEX = "soundex"
  PROCESS_SEARCHABLE = "searchable"

  @processes = [PROCESS_EXACT, PROCESS_SOUNDEX, PROCESS_SEARCHABLE]

  validates_uniqueness_of :name
  validates_presence_of  :process, :in => @processes

  before_validation :downcase_name

  def downcase_name
    if name_changed? and name.downcase != name
      self.name = self.name.downcase
    end
  end

  class << self
    def find_all_candidates(string)
      candidates = []
      @processes.each do |process|
        candidates += self.send("find_with_process_#{process.downcase}", string)
      end
      candidates.reject {|x| !x}.uniq
    end

    def find_best_candidate(string)
      name = find_all_candidates(string).sort {|a,b| b.confidence <=> a.confidence }.first
      name && name.show
    end

    def find_with_process_exact(string)
      find(:all, :conditions => ["process = ? and (LOWER(name) = ? or soundex = ?)", PROCESS_EXACT,
                                 string.downcase, SearchUtils.soundex(string)])
    end

    def find_with_process_soundex(string)
      find(:all, :conditions => ["process = ? and name = ?", PROCESS_SOUNDEX, SearchUtils.soundex(string)])
    end

    def find_with_process_searchable(string)
      find(:all, :conditions => ["process = ? and LOWER(name) = ?", PROCESS_SEARCHABLE,
                                 SearchUtils.searchable_string(string).downcase])
    end

  end
end
