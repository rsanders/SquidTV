class EpisodeSpec
  attr_reader :series, :season, :episode, :title, :valid

  class << self
    def split_episode_identifier(num)
      if num.size == 3
        season = num[0..0]
        episode = num[1..-1]
      else
        season = num[0..1]
        episode = num[2..-1]
      end
      [season, episode]
    end

    def parse_filename(name)
      # name = name.gsub(/\.[^.]+$/, '')
      origname = name
      name = name.gsub(/[<>\[\]()+=._ \t-]+/, ' ')
      match = name.match(/^(.*)\s[sS](\d+)\s*[eE](\d+)(.*)\s([^ ]{2,5})$/) ||
              name.match(/^(.*)\s(\d+)x(\d+)(.*)\s([^ ]{2,5})$/) ||
              name.match(/^(.*)\s(\d)([012]\d)(.*)\s([^ ]{2,5})$/)

      if match
        return EpisodeSpec.new match[1], match[2], match[3], match[4].strip
      end

      # for "103 - Series Name.avi" style names
      match = origname.strip.match(/^(\d+)\s*[\s_-]\s*([^_-]+)(\s*[_-]\s*.*)?\.[a-zA-Z0-9]+$/)
      if match
        (season, number) = split_episode_identifier match[1]
        return EpisodeSpec.new match[2], season, number, match[3]
      end

      nil
    end

    def strip_title(title)
      return title unless title

      title.gsub(/\b(hdtv|xvid|vtv|fqm|lol|xii|sdtv|720p|1080p|x264|bluray|blu-ray|ws|readnfo|dvdscr|ts|fqm|sys)\b.*$/i, '').strip.titleize
    end

    def strip_series(series)
      (2005..2015).each do |year|
        if series.end_with? " #{year}"
          return series[0..-6]
        end
      end
      series
    end
  end

  def initialize(series, season, episode, title = nil, valid = true)
    @series = EpisodeSpec.strip_series(series).titleize
    @season = season.to_i rescue @season
    @episode = episode.to_i rescue @episode
    @title = EpisodeSpec.strip_title title
    @valid = valid
  end

  def title
    @title || "S#{season}E#{episode}"
  end

  def to_filename(ext = ".avi")
    str = sprintf "%s.S%02dE%02d%s%s", @series, @season, @episode, (@title ? ".#{@title}": ""), ext
    str.gsub(/ /, '.')
  end
end
