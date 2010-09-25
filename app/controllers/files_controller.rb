class FilesController < ApplicationController
  def index
    @files = Phile.existing.where("file_modified_at >= ?", 6.months.ago).includes(:media_root)
  end

end
