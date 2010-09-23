class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_filter :adjust_format_for_iphone

  def adjust_format_for_iphone
    if request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod)/]
      request.format = :iphone
    end
  end
end
