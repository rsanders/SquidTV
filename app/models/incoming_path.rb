require_dependency "db_lockable"

class IncomingPath < ActiveRecord::Base
  scope :active, :conditions => {:active => true}
  scope :inactive, :conditions => {:active => false}

  before_validation :load_filesystem_data

  validates_uniqueness_of :path

  include ::DBLockable

  class << self
    def find_root_for_path(path)
      roots = self.active.sort {|a,b| b.path.size <=> a.path.size }
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

      logger.debug  "importing #{path} as movie"
      next
    end
  end

  def scan
    start = Time.now.utc

    # implicit Transaction here
    with_lock do
      logger.info "=== Scanning #{self.path} for incoming files..."
      add_all_files
      self.update_attributes :scanned_at => start
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
    if !path.empty? && (new_record? || path_changed?)
      self.local = StatFS.statfs(path).local? rescue false
    end
  end
end
