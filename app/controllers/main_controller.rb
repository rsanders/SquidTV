class MainController < ApplicationController
  def index
    Phile.root = APP_CONFIG[:roots]["tv"]
    @files = Phile.list_all.reject {|file| file.modified_at < 4.months.ago}
  end

end
