require "redcarpet"

require_relative "./template.rb"

class Markup
  def initialize(layout_path)
    @content = {}
    @templates = {}
    @layout_path = layout_path
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

  def walk()
    for file in Dir["content/**/*.md"]
      @content[file.sub("content/", "").sub(".md", "").to_sym] = parse_markdown(file)
    end
  end

  def compile()
    walk
    @content.each do |key, meta_data|
      layout = (meta_data[:layout]).delete_prefix('"').delete_suffix('"')
      if layout
        layout_file_path = @layout_path + "/" + layout
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
  end
end
