class ShowManager
  def initialize

  end

  def singleton
    @instance ||= ShowManager.new
  end

  def find_or_create_show(name)
    show = Show.find_from_string(name)
    if ! show
      show = load_show(name)
    end
    show
  end

  def load_show(name)
    cdb = CentralTVDatabase.new

    tvd_show = cdb.find_series_by_name(name)
    return nil unless tvd_show

    local_show = Show.find_by_tvdb_id(tvd_show.id)
    return local_show if local_show

    attrs = {:name => tvd_show.name,
             :tvdb_id => tvd_show.id,
             :first_aired_at => tvd_show.first_aired,
             :network => tvd_show.network,
             :overview => tvd_show.overview,
             :runtime => tvd_show.runtime,
             :url => cdb.series_web_page(tvd_show)
    }

    Show.create attrs
  end
end
