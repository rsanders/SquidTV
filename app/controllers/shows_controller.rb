require_dependency 'meta_searchable'

class ShowsController < ApplicationController
  inherit_resources
  respond_to :html, :json, :js, :xml

  has_scope :recent

  include MetaSearchable

  protected

  def collection
    if ! @shows
      col = end_of_association_chain
      unless params[:search] && params[:search][:meta_sort]
        col = col.order("sortable_name asc")
      end
      @shows = col
    end
    @shows
  end
end
