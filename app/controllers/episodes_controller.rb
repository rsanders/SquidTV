class EpisodesController < ApplicationController
  inherit_resources

  belongs_to :show, :optional => true

  protected

  def collection
    @episodes ||= end_of_association_chain.unseen.where("created_at >= ?", 6.months.ago).order("aired_at desc")
  end
end
