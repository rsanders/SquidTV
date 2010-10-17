class ApplicationController < ActionController::Base
  protect_from_forgery

  has_mobile_fu

  def is_device_with_cookie?(device)
    puts "with cookie called!"
    if cookies[:site_variant] == "normal"
      false
    elsif cookies[:site_variant] == device
      true
    else
      is_device_without_cookie?(device)
    end
  end

  def is_mobile_device_with_cookie?
    puts "imb with cookie called!"
    if cookies[:site_variant] == "normal"
      false
    elsif ! cookies[:site_variant].empty?
      true
    else
      is_mobile_device_without_cookie?
    end
  end

  alias_method_chain :is_device?, :cookie
  alias_method_chain :is_mobile_device?, :cookie


#  before_filter :adjust_format_for_mobile
#
#  def adjust_format_for_mobile
#    if cookies[:site_variant] == "mobile" ||
#            (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad)/] &&
#                    cookies[:site_variant] != "normal")
#      request.format = "mobile"
#      logger.debug "got mobile"
#    end
#    true
#  end
end
