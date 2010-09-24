require_dependency "db_lockable"

class MediaRoot < ActiveRecord::Base
  has_many :philes, :dependent => :destroy

  scope :active, :conditions => {:active => true} 
  scope :inactive, :conditions => {:active => false}

  validates_uniqueness_of :path

  include DBLockable

  def scan
    with_lock do
      Phile.list_all(self).map &:save!
      self.update_attributes :scanned_at => Time.now.utc
    end
  end

  def scan_if_scheduled
    scan if self.ready_to_scan?
  end

  def ready_to_scan?
    self.scanned_at + self.scan_period < Time.now
  end

end
