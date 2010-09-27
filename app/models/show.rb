class Show < ActiveRecord::Base
  has_many :episodes, :dependent => :destroy do
    def latest
      order("season desc, number desc").limit(1).first
    end
  end

  has_many :show_names, :dependent => :destroy
  has_many :philes, :through => :episodes

  scope :recent, lambda { active_since(3.months.ago) }

  before_save :update_aliases

  validates_uniqueness_of  :name
  validates_uniqueness_of  :sortable_name
  validates_uniqueness_of  :tvdb_id, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of  :url, :allow_nil => true, :allow_blank => true

  class << self
    def active_since(date)
      ids = Show.find_by_sql("select s.id from shows as s
join episodes as e on e.show_id = s.id
group by s.id
having max(aired_at) > '#{date}'
order by max(aired_at) desc")
      Show.where(:id => ids)
    end


    def make_sortable_string(string)
      string = string.titleize
      ["A", "An", "The"].each do |word|
        if string.start_with? "#{word} "
          string = string[word.length+1..-1] + ", #{word}"
          break
        end
      end
      string.downcase
    end

    def find_from_string(string)
      find(:first, :conditions => ["LOWER(name) = ?", string.downcase]) ||
              find_by_sortable_name(make_sortable_string(string)) || ShowName.find_best_candidate(string)
    end
  end

  def update_aliases
    if name_changed? || new_record?
      make_aliases
    end
  end

  def make_aliases
    self.sortable_name = Show.make_sortable_string(name)
    # ShowName.populate_aliases(self, self.name)
  end

  def has_alias?(string, process=nil)
    base = self.show_names
    if process
      base = base.where("process = ?", process)
    else
      return true if name.downcase == string.downcase || sortable_name.downcase == string.downcase
    end
    base.where("LOWER(name) = ?", string.downcase).count > 0
  end

  def episode(season, number)
    self.episodes.where("season = ? and number = ?", season, number).first
  end

  def add_episode(season, number, title = nil)
    epi = self.episodes.find_or_initialize_by_season_and_number :season => season, :number => number
    if epi.new_record?
      CentralTVDatabase.new.add_episode_metadata(epi)
      epi.title ||= title
      epi.save!
    end

    epi
  end
end
