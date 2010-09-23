# Load the rails application
require File.expand_path('../application', __FILE__)

require File.join(File.dirname(__FILE__), '../lib/appconfig.rb')

# Initialize the rails application
Torvguide::Application.initialize!

