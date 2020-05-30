require "json"
require "redcarpet"

require_relative "./template.rb"

class Zepto
  def initialize(config)
    @ignore = config[:ignore]
    @images = config[:images]
    @layout = config[:layout]
    @styles = config[:styles]
    @javascript = config[:javascript]
    @offline = config[:offline]
    @content = {}
    # Storing templates so that caching builds
    @templates = {}
    @styles_content = {}
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true,
                                                                 strikethrough: true, highlight: true,
                                                                 superscript: true)
  end

  def read(path)
    if File.file? path
      return File.read(path)
    else
      raise "File #{path} does not exist"
    end
  end

  # TODO: Move Parse to seperate Class
  # Extracts content and header from markdown and converts markdown to HTML
  def parse_markdown(path)
    file_content = read path

    header = file_content.match(/-{3,}(.+)-{3,}/m)
    post = {}
    post[:path] = path.sub("content/", "").sub(".md", "")

    if header
      header_data = header.captures[0].split("\n").reject! { |s| s.nil? || s.strip.empty? }

      for header in header_data
        key, value = header.split(":", 2)
        post[key.strip.to_sym] = value.strip
      end
    end

    post[:content] = @markdown.render(file_content.gsub(/-{3,}(.+)-{3,}/m, ""))
    return post
  end

  def parse_css(path)
    file_content = read path
    return file_content
  end

  # TODO: Move Walk to seperate class
  def walk_content()
    for file in Dir["content/**/*.md"]
      @content[file.sub("content/", "").sub(".md", "").to_sym] = parse_markdown(file)
    end
  end

  def walk_styles()
    for file in Dir[@styles + "/**/*.css"]
      @styles_content[file.sub(@styles + "/", "").sub(".css", "").to_sym] = parse_css(file)
    end
  end

  def serve
    puts "Starting server in port 3000"
    walk_content
  end

  def build
    puts "Building static files"
    walk_content
    walk_styles

    # Building Layouts
    @content.each do |key, meta_data|
      layout = (meta_data[:layout]).delete_prefix('"').delete_suffix('"')
      if layout
        layout_file_path = @layout + "/" + layout
        if File.file?(layout_file_path)
          template = File.read(layout_file_path)
          path = meta_data[:path]
          @templates[path] = Template.new(template, meta_data)
          @templates[path].render
          @templates[path].write
        else
          raise "File #{layout_file_path} is not found"
        end
      else
        raise "You have not specified any layout for #{key}"
      end
    end

    puts @styles_content
    # Building styles
    @styles_content.each do |key, content|
      view_path = Pathname("dist/" + key.to_s.delete_prefix('"').delete_suffix('/"') + ".css")
      view_path.dirname.mkpath
      view_path.write(content)
    end
  end
end
