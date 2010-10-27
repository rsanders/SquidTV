source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
unless defined?(JRuby)
  gem 'ruby-debug'
end

# inherited resources
gem 'inherited_resources', '1.1.2'
gem 'inherited_resources_views'
gem 'responders'
gem 'has_scope'

# for filesystem event watching
# gem 'fssm'

# gem 'rack-bug'

gem 'newrelic_rpm', '2.13.1'

# video processing
gem 'streamio-ffmpeg'

# tvdb api
gem 'tvdb_party'

# for statfs
gem 'ffi'

gem 'rack-offline', :path => 'vendor/gems/rack-offline'

# for admin
# gem 'admin_data'

# various hacks and plugins
gem "meta_where"
gem "meta_search"

# forget JS, I'm doing coffeescript now
gem 'barista', '>= 0.5.0'

# about to get meta-css and html5-boilerplatey
gem 'haml'
gem 'html5-boilerplate'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'webrat'
  unless defined?(JRuby) 
    gem 'ruby-prof'
  end
  gem 'rspec', ">= 2.0.0.beta.22"
  gem 'rspec-rails', ">= 2.0.0.beta.22"
  # gem 'rails-footnotes'
  # gem 'fakefs'
end

group :console do
  gem 'wirble'
  gem 'bond'
  gem 'hirb'
  gem 'utility_belt'
  unless defined?(JRuby) 
    gem 'looksee'
  end
end
