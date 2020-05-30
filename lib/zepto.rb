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

  # Extracts content and header from markdown and converts markdown to HTML
  def parse(path)
    file_content = read path

    header = file_content.match(/-{3,}(.+)-{3,}/m)
    post = {}

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

  def walk()
    for file in Dir["content/**/*.md"]
      @content[file.sub("content/", "").sub(".md", "").to_sym] = parse(file)
    end
  end

  def serve
    puts "Starting server in port 3000"
    walk
  end

  def build
    puts "Building static files"
    walk

    @content.each do |key, meta_data|
      layout = (meta_data[:layout]).delete_prefix('"').delete_suffix('"')
      if layout
        layout_file_path = @layout + "/" + layout
        if File.file?(layout_file_path)
          template = File.read(layout_file_path)
          Template.new(template, meta_data).render
        else
          raise "File #{layout_file_path} is not found"
        end
      else
        raise "You have not specified any layout for #{key}"
      end
    end
  end
end
