module MetaSearchable
  #Code here
  def self.included(base)
    base.send :include, InstanceMethods
    base.class_eval do
      before_filter :setup_search, :only => [:index]
      alias_method_chain :collection, :search
    end
  end

  module InstanceMethods
    protected
    def setup_search
      @search = collection.search(params[:search])
    end

    def collection_with_search
      @search = end_of_assocation_chain.search(params[:search])
      if params[:search]
        collection_without_search.search(params[:search])
      else
        collection_without_search
      end
    end
  end

end
