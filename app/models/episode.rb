require_dependency 'groupify'
``
class Episode < ActiveRecord::Base
  belongs_to :show, :counter_cache => true
  belongs_to :phile
  has_one    :seen, :dependent => :destroy

  validates_uniqueness_of :number, :scope => [:show_id, :season]
  validates_uniqueness_of :unique_number, :scope => [:show_id],
                          :allow_nil => true, :allow_blank => true
  

  # XXX - temp hack until we figure out seen state
  scope :unseen, :conditions => "seen_at is null"

  scope :recent, :conditions => ["aired_at >= ?", 3.months.ago]

  def mark_seen!
    update_attributes :seen_at => Time.now.utc
    show.update_cached_values
  end

  def mark_unseen!
    update_attributes :seen_at => nil
    show.update_cached_values
  end

  def valid_numbers?
    ! (season.blank? || season.to_s == "0" || number.blank? || number.to_s == "0")
  end

  def show_name
    show.name
  end

  # XXX: this is so very wrong
  def time_category
    ActionController::Base.helpers.time_ago_in_words Groupify.groupify([self], Proc.new {|ep| ep.aired_at || ep.phile.file_created_at })[0][0]
  end

  def as_json(options={})
    serializable_hash( :methods => [:show_name, :time_category], :include =>[:show])
  end
end
