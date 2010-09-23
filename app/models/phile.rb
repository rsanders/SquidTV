require 'find'

class Phile
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  include ActiveModel::Naming

  cattr_accessor :root
  attr_accessor :name, :path, :modified_at, :created_at, :accessed_at


  class << self
    def from_path(path)
      stat = File.stat path
      Phile.new :path => path, :name => File.basename(path), :modified_at => stat.mtime,
           :created_at => stat.ctime, :accessed_at => stat.atime
    end

    # see http://www.fileinfo.com/filetypes/video
    def is_movie?(name)
      ext = name.split('.').last.downcase
      ["mp4", "m4v", "mpeg", "mpg", "mov", "mkv", "mp2", "avi", "wmv", "qt",
       "asf", "vob", "flv", "3g2", "3gp", "rm", "xvid", "dvix", "f4v", "hdmov", "mts",
       "ogm", "ogv", "rmvb", "ts", "yuv", "webm"].include? ext
    end

    def list_all(root = nil, options = {:sort => :newest})
      root ||= self.root

      list = []
      Find.find(root) do |path|
        base = File.basename(path)
        if base[0..0] == "."
          Find.prune if FileTest.directory?(path)
          next
        end

        next if FileTest.symlink?(path) || FileTest.directory?(path) || ! is_movie?(base)
        list << Phile.from_path(path)
        next
      end

      list.sort {|a,b| b.modified_at <=> a.modified_at }
    end
  end

  # attr_accessor :attributes
  def initialize(attributes = {})
    attributes.each do |key,value|
      self.send "#{key.to_s}=", value 
    end
  end

  def attributes
    {}.tap do |res|
      [:name, :path, :modified_at, :created_at, :accessed_at].map {|key| res[key.to_s] = self.send key }
    end
  end

  def group
    if Phile.root and path.start_with? Phile.root
      path[Phile.root.size+1..-1].gsub(/\/.*$/, '')      
    else
      File.basename File.dirname(path)
    end
  end

  def episode_spec
    spec = EpisodeSpec.parse_filename self.name
    return spec if spec

    if Phile.root and path.start_with?(Phile.root)
      parts = path[Phile.root.size+1..-1].split('/')
      season = 0
      episode = 0

      if parts.size > 2
        show = parts[0] + " " + parts[1]
      else
        show = parts[0]
      end
      if match=self.name.match(/(\d{3,4})[. _-]/)
        num = match[1]
        if num.size == 3
          season = num[0..0]
          episode = num[1..-1]
        else
          season = num[0..1]
          episode = num[2..-1]
        end
      end

      return EpisodeSpec.new show, season, episode, self.name
    end

    EpisodeSpec.new group, 0, 0, self.name
  end

end
