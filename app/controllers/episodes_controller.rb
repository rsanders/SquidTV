require_dependency 'meta_searchable'

class EpisodesController < ApplicationController
  inherit_resources
  respond_to :html, :json, :js, :xml
  
  belongs_to :show, :optional => true
  # belongs_to :phile, :singleton => true, :optional => true

  has_scope :recent

  # include MetaSearchable

  def watch
    resource.mark_seen!
    respond_to do |fmt|
      fmt.html { redirect_to :episodes }
      fmt.json { head :code => 200 }
      fmt.js {
          render :update do |page|
            page["episode_#{resource.id}"].replace :partial => "episode", :object => resource
          end
      }
    end
  end

  def unwatch
    resource.mark_unseen!
    respond_to do |fmt|
      fmt.html { redirect_to :episodes }
      fmt.json { head :code => 200 }
      fmt.js {
          render :update do |page|
            page["episode_#{resource.id}"].replace :partial => "episode", :object => resource
          end
      }
    end
  end


  protected

  def collection
    base = end_of_association_chain
    base = base.unseen unless params[:seen] || params[:all]
    if ! @show
      base = base.where("aired_at >= ?", 6.months.ago)
    end
    @episodes ||= base.order("aired_at desc").includes([:show, :phile])
  end
end
