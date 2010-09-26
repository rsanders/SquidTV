Bundler.require :console

UtilityBelt.equip(:pastie)
UtilityBelt::Themes.background(:dark)

class Object
  # Return only the methods not present on basic objects
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end

  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER') && defined?(Rails::Console)
 require 'logger'
 RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
 ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
end
