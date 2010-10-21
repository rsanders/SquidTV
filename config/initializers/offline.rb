TORV_OFFLINE = Rails::Offline.configure do
  files = Dir[
    "#{root}/**/*.html",
    "#{root}/stylesheets/**/*.css",
    "#{root}/javascripts/**/*.js",
    "#{root}/jqm/**/*.*",
    "#{root}/images/**/*.*"]

  files.each do |file|
    cache Pathname.new(file).relative_path_from(root)
  end

  network "/"
end
