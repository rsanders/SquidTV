require 'erb'
require 'active_support/core_ext/hash'

ALL_APP_CONFIGS = YAML::load(ERB.new((IO.read("#{::Rails.root.to_s}/config/settings.yml"))).result)
APP_CONFIG = ((ALL_APP_CONFIGS['all'] || {}).merge(ALL_APP_CONFIGS[::Rails.env] || {})).symbolize_keys
