class PhilesController < ApplicationController
  inherit_resources
  respond_to :html, :json, :js, :xml

  # belongs_to :episode, :singleton => true, :optional => true
  # belongs_to :show, :optional => true

  protected
  
  def collection
    @files ||= Phile.existing.where("file_modified_at >= ?", 6.months.ago).includes([:media_root, :episode])
  end

end
