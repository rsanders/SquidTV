class ShowsController < ApplicationController
  inherit_resources

  def recent
    @shows ||= end_of_association_chain.active_since(3.months.ago).order("name asc")
  end

  protected

  def collection
    @shows ||= end_of_association_chain.order("name asc")
  end
end
