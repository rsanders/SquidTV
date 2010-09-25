class MainController < ApplicationController
  def index
    @files = Phile.existing.where("file_modified_at >= ?", 6.months.ago).includes(:media_root)

  end

  def episodes
    @episodes = Episode.unseen.where("created_at >= ?", 6.months.ago).order("aired_at desc")

  end
end
