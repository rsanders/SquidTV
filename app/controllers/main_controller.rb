class MainController < ApplicationController
  def index
  end

  def variant
    cookies[:site_variant] = params[:variant]
    session[:mobile_view] = case params[:variant]
                              when nil, "", "normal" then false
                              else true
                            end
    redirect_to :root
  end

end
