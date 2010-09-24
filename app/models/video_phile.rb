class VideoPhile < Phile
  def process
    process_video_phile
  ensure
    super
  end

  def process_video_phile
    # TODO: conditionalize this on media_root
    process_episode
  end

  def process_episode
    spec = self.episode_spec

    show = ShowManager.new.find_or_create_show(spec.series)
    if ! show
      logger.info "Cannot find show for #{spec.series}, #{self.inspect}"
      return false
    end

    if spec.season && spec.season.to_s != "0" && spec.episode && spec.episode.to_s != "0"
      episode = show.add_episode spec.season, spec.episode, spec.title
      episode.phile = self
      episode.save
    end

    true
  end


  def episode_spec
    spec = EpisodeSpec.parse_filename self.filename
    return spec if spec

    if self.media_root and path.start_with?(self.media_root.path)
      parts = path[self.media_root.path.size+1..-1].split('/')
      season = 0
      episode = 0

      show = parts[0]

      if match=self.filename.match(/(\d{3,4})[. _-]/)
        num = match[1]
        if num.size == 3
          season = num[0..0]
          episode = num[1..-1]
        else
          season = num[0..1]
          episode = num[2..-1]
        end
      end

      if (season == 0 || episode == 0) and parts.size > 2
        show = show + " " + parts[1]
      end


      return EpisodeSpec.new show, season, episode, self.filename
    end

    # default, but mark it invalid
    EpisodeSpec.new group, 0, 0, self.filename, false
  end
end
