require 'find'

class Phile < ActiveRecord::Base
  belongs_to :media_root

  has_one  :movie, :dependent => :destroy
  has_one  :episode, :dependent => :destroy
  has_one  :seen, :dependent => :destroy

  scope :deleted, :conditions => ["deleted_at is not null"]
  scope :existing, :conditions => ["deleted_at is null"]

  scope :processed, :conditions => ["processed_at IS NOT NULL"]
  scope :unprocessed, :conditions => ["processed_at IS NULL"]
  scope :not_processed_recently, :conditions => ["processed_at IS NULL OR processed_at < ?",
                                                 Time.now.utc - 2.hours.ago]
  scope :unresolved, :conditions => ["resolved = ?", false]

  before_validation :set_empty_fields_from_file

  validates_uniqueness_of :path
  validates_uniqueness_of :inum, :scope => [:device], :allow_nil => true

  def set_empty_fields_from_file
    self.format ||= filename.split('.').last.downcase if filename.include?('.')
  end

  class << self
    def from_path(path, root = nil)
      stat = File.stat path
      Phile.new :path => path, :filename => File.basename(path), :file_modified_at => stat.mtime,
           :file_created_at => stat.ctime, :file_accessed_at => stat.atime, :size => stat.size,
           :media_root => root, :device => stat.dev, :inum => stat.ino
    end

    # see http://www.fileinfo.com/filetypes/video
    def is_movie?(name)
      ext = name.split('.').last.downcase
      ["mp4", "m4v", "mpeg", "mpg", "mov", "mkv", "mp2", "avi", "wmv", "qt",
       "asf", "vob", "flv", "3g2", "3gp", "rm", "xvid", "dvix", "f4v", "hdmov", "mts",
       "ogm", "ogv", "rmvb", "ts", "yuv", "webm"].include? ext
    end

    def list_all(root = nil, options = {:sort => :newest})
      raise "Must specify media root" unless root

      list = []
      Find.find(root.path) do |path|
        base = File.basename(path)
        if base[0..0] == "."
          Find.prune if FileTest.directory?(path)
          next
        end

        next if FileTest.symlink?(path) || FileTest.directory?(path) || ! is_movie?(base)
        list << Phile.from_path(path, root)
        next
      end

      list.sort {|a,b| b.file_modified_at <=> a.file_modified_at }
    end
  end

  def mark_alive!
    self.update_attributes! :updated_at => Time.now
  end

  def mark_deleted!
    self.update_attributes! :deleted_at => Time.now
  end

  def mark_processed!
    self.update_attributes! :processed_at => Time.now
  end

  def mark_resolved!
    self.update_attributes! :resolved => true
  end

  def process
    mark_processed!
  end

  def deleted?
    !! deleted_at
  end

  def available?
    !deleted? && self.media_root && self.media_root.active && File.exists?(self.path)
  end

  ## parsing

  def group
    if self.media_root and path.start_with? self.media_root.path
      path[self.media_root.path.size+1..-1].gsub(/\/.*$/, '')
    else
      File.basename File.dirname(path)
    end
  end


end
