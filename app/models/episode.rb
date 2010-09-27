class Episode < ActiveRecord::Base
  belongs_to :show
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
  end

  def mark_unseen!
    update_attributes :seen_at => nil
  end

  def valid_numbers?
    ! (season.blank? || season.to_s == "0" || number.blank? || number.to_s == "0")
  end
end
