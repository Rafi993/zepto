require_relative "./markup.rb"
require_relative "./styles.rb"
require_relative "./javascript.rb"

class Zepto
  def initialize(config)
    @ignore = config[:ignore]
    @assets_path = config[:assets]
    @layout = config[:layout]
    @styles_path = config[:styles]
    @javascript_path = config[:javascript]
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

    # Minifying js
    javascript = Javascript.new(@javascript_path)
    javascript.compile()

    # Copying assets in to dist/
    if File.directory? @assets_path
      FileUtils.cp_r @assets_path + "/.", "dist"
    end
  end
end
