require "json"

require_relative "./markup.rb"
require_relative "./styles.rb"

class Zepto
  def initialize(config)
    @ignore = config[:ignore]
    @images = config[:images]
    @layout = config[:layout]
    @styles_path = config[:styles]
    @javascript = config[:javascript]
    @offline = config[:offline]
  end

  def serve
    puts "Starting server in port 3000"
  end

  def build
    puts "Building static files"

    # Building Layouts
    markup = Markup.new(@layout)
    markup.compile()

    # Building styles
    styles = Styles.new(@styles_path)
    styles.compile()
  end
end
