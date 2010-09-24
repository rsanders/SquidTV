require_dependency "db_lockable"

class MediaRoot < ActiveRecord::Base
  has_many :philes, :dependent => :destroy do
    def stale
      where("updated_at < ?", proxy_owner.scanned_at.utc)
    end
  end

  scope :active, :conditions => {:active => true} 
  scope :inactive, :conditions => {:active => false}

  before_validation :load_filesystem_data

  validates_uniqueness_of :path

  include DBLockable

  class << self
    def find_root_for_path(path)
      roots = MediaRoot.active.sort {|a,b| b.path.size <=> a.path.size }
      roots.each do |root|
        return root if root.contains_path?(path)
      end
      nil
    end
  end

  def add_all_files
    list = []
    Find.find(path) do |path|
      base = File.basename(path)
      if base[0..0] == "."
        Find.prune if FileTest.directory?(path)
        next
      end

      next if FileTest.symlink?(path) || FileTest.directory?(path) || ! Phile.is_movie?(base)
      if phile=Phile.find_by_path(path)
        phile.mark_alive!
      else
        Phile.from_path(path, self).save!
      end

      next
    end
  end

  def scan
    start = Time.now.utc

    # implicit Transaction here
    with_lock do
      self.update_attributes :scanned_at => start

      add_all_files

      philes.where("updated_at < ?", start).each do |phile|
        phile.mark_deleted!
      end

    end
  end

  def scan_if_scheduled
    scan if self.ready_to_scan?
  end

  def ready_to_scan?
    !self.scanned_at or self.scanned_at + self.scan_period < Time.now
  end

  def contains_path?(path)
    path.start_with? self.path
  end

  protected

  # get real-world state about this
  def load_filesystem_data
    
  end

end
