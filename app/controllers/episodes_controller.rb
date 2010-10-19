require_dependency 'meta_searchable'

class EpisodesController < ApplicationController
  inherit_resources
  respond_to :html, :json, :js, :xml, :mobile
  
  belongs_to :show, :optional => true
  # belongs_to :phile, :singleton => true, :optional => true



  has_scope :recent

  before_filter { @title = "Episodes" }

  # include MetaSearchable

#  def index
#    collection
#    respond_to do |fmt|
#      fmt.mobile { render }
#      fmt.xml { render :xml => collection }
#      fmt.json { render :json => collection.to_json(:include => [:show]) }
#      fmt.html
#    end
#  end

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

    # XXX - hack to work around jQuery Mobile crashes
    if in_mobile_view?
      base = base.limit(40)
    end
    @episodes ||= base.order("aired_at desc").includes([:show, :phile])
  end
end
