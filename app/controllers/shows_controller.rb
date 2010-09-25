class ShowsController < ApplicationController
  inherit_resources

  protected

  def collection
    @shows ||= end_of_association_chain.order("name asc")
  end
end
