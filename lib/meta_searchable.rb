module MetaSearchable
  #Code here
  def self.included(base)
    base.send :include, InstanceMethods
    base.class_eval do
      before_filter :setup_search, :only => [:index]
      alias_method_chain :end_of_association_chain, :search
    end
  end

  module InstanceMethods
    protected
    def setup_search
      @search = end_of_association_chain_without_search.search(params[:search])
    end

    def end_of_association_chain_with_search
      @search = end_of_association_chain_without_search.search(params[:search])
      if params[:search]
        end_of_association_chain_without_search.search(params[:search])
      else
        end_of_association_chain_without_search
      end
    end
  end

end
