class EpisodeSpec
  attr_reader :series, :season, :episode

  def self.parse_filename(name)
    name = name.gsub(/[<>()+=._ \t-]+/, ' ')
    match = name.match(/^(.*)\s[sS](\d+)\s*[eE](\d+)(.*)\s([^ ]{2,5})$/) ||
            name.match(/^(.*)\s(\d+)x(\d+)(.*)\s([^ ]{2,5})$/) ||
            name.match(/^(.*)\s(\d)([012]\d)(.*)\s([^ ]{2,5})$/)

    if match
      EpisodeSpec.new match[1], match[2], match[3], match[4].strip
    else
      nil
    end
  end

  def self.strip_title(title)
    return title unless title

    title.gsub(/ (hdtv|xvid|vtv|fqm|lol|xii|sdtv|720p|1080p|x264|bluray|blu-ray|ws) .*$/i, '')
  end

  def self.strip_series(series)
    (2005..2015).each do |year|
      if series.end_with? " #{year}"
        return series[0..-6]
      end
    end
    series
  end

  def initialize(series, season, episode, title = nil)
    @series = EpisodeSpec.strip_series series
    @season = season.to_i rescue @season
    @episode = episode.to_i rescue @episode
    @title = EpisodeSpec.strip_title title
  end

  def title
    @title || "S#{season}E#{episode}"
  end

  def to_filename(ext = ".avi")
    str = sprintf "%s.S%02dE%02d%s%s", @series, @season, @episode, (@title ? ".#{@title}": ""), ext
    str.gsub(/ /, '.')
  end
end
