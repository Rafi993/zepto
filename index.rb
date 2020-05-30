require "json"

require_relative './zepto'

default_config_file = File.open "default_config.json"
default_config = JSON.load default_config_file

case ARGV[0]
when "serve"
  puts "Starting server in port 3000"
when "build"
  puts "Building static files"
when "help"
  puts %(
         zepto serve: To serve the files locally in dev mode
         zepto build: Building for production
         zepto help: Help options

         For more details visit https://github.com/Rafi993/zepto
        )
else
  puts "I don't understand the command. Try running 'zepto help'"
end

# puts default_config