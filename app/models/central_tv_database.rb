require 'tvdb_party'
require_dependency 'search_utils'

class CentralTVDatabase
  def api
    @api ||= TvdbParty::Search.new(APP_CONFIG[:tvdb_api_key])
  end

  def find_series_by_id(id)
    api.get_series_by_id(id)
  end

  def find_series_by_name(name)
    results = api.search(name)
    results = api.search(SearchUtils.searchable_string(name)) if results.blank?

    return nil if results.blank?
    find_series_by_id results.first["seriesid"]
  end

  def find_canonical_name(name)
    results = api.search(name)
    results = api.search(SearchUtils.searchable_string(name)) if results.blank?

    return nil if results.blank?
    results && results.first["SeriesName"]
  end

  def series_web_page(series)
    number = nil
    if series.is_a? Numeric
      number = series
    elsif series.is_a? String
      series = self.find_series_by_name(series)
      number = series && series.id
    elsif series.is_a? Show and !series.tvdb_id.blank?
      number = series.tvdb_id
    elsif series.respond_to? :actors
      number = series.id
    end

    # fallback for numeric strings
    if !number and series.is_a? String and series.match(/^\d+$/)
      number = series
    end

    raise "Cannot get series ID" unless number && number != 0 && number != "0"

    "http://thetvdb.com/?tab=series&id=#{number}"
  end

  # takes a Rails model object and adds good stuff to it
  def add_episode_metadata(episode)
    return false unless episode.valid_numbers?

    show = episode.show
    return false unless show

    api_show = show.tvdb_id ? find_series_by_id(show.tvdb_id) : find_series_by_name(show.name)

    return false unless api_show

    api_episode = api_show.get_episode episode.season, episode.number

    return false unless api_episode

    episode.tvdb_id = api_episode.id
    episode.aired_at = api_episode.air_date
    episode.title = api_episode.name
    episode.overview = api_episode.overview

    true
  end
end
