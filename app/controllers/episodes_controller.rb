class EpisodesController < ApplicationController

  def index
    @episodes = Episode.unseen.where("created_at >= ?", 6.months.ago).order("aired_at desc")
  end
end
