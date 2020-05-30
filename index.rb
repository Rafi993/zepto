require "json"

require_relative './zepto'

default_config_file = File.open "default_config.json"
default_config = JSON.load default_config_file

puts default_config