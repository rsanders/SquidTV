require_dependency 'meta_searchable'

class ShowsController < ApplicationController
  inherit_resources
  respond_to :html, :json, :js, :xml

  has_scope :recent

  include MetaSearchable

  protected

  def collection
    @shows ||= end_of_association_chain.order("name asc")
  end
end
