class ApplicationController < ActionController::Base
  protect_from_forgery

  has_mobile_fu

  before_filter  :set_format_for_jqmobile

  ##
  ## XXX: this breaks XHR for other content types, so it's just a hack ATM#
  ##
  ## jQuery Mobile makes XHR requests for content snippets, but leaves
  ## the Accept header at */* and does not explicitly set any vars or
  ## formats.  This confuses our controllers.
  ##
  ## To use this:
  ## Normal links will have no specific format in the params. Nor will
  ## inter-page links auto-XHR-ified by jQuery Mobile.  This is most
  ## convenient.  But application XHR requests *should* include a specific
  ## .js or .json or .xml or .csv extension or whatever, to bypass this
  ## workaround.
  ##
  ##
  def set_format_for_jqmobile
    if request.xhr? and is_mobile_device? and ! ["js", "json", "xml", "csv"].include?(params[:format].to_s)
      request.format = :mobile
    end
  end

  def is_device_with_cookie?(device)
    variant = cookies[:site_variant] || params[:variant]
    if variant == "normal"
      false
    elsif variant == device
      true
    else
      is_device_without_cookie?(device)
    end
  end

  def is_mobile_device_with_cookie?
    variant = cookies[:site_variant] || params[:variant]

    if variant == "normal"
      false
    elsif variant && ! variant.empty?
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
