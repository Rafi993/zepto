require "redcarpet"
require "set"

require_relative "./template.rb"

class Markup
  def initialize(layout_path)
    @content = {}
    @templates = {}
    @tags = Set.new
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
        post[key.strip.to_sym] = value.strip.delete_prefix('"').delete_suffix('"')
      end
    end

    post[:content] = @markdown.render(file_content.gsub(/-{3,}(.+)-{3,}/m, ""))

    tags = Set.new
    # Converting tags to Set
    if post.has_key? :tags
      for tag in post[:tags].to_s.delete_prefix("[").delete_suffix("]").split(/,/)
        tag_name = tag.strip.delete_prefix('"').delete_suffix('"').strip
        tags.add(tag_name)
        # Storing all tags in @tags
        @tags.add(tag_name)
      end
    end
    post[:tags] = tags

    return post
  end

  def walk()
    for file in Dir["content/**/*.md"]
      @content[file.sub("content/", "").sub(".md", "").to_sym] = parse_markdown(file)
    end
  end

  def get_tags
    return @tags
  end

  def get_tag(tag)
    if @tags.include?(tag)
      content_with_tag = []
      @content.each do |key, meta_data|
        if meta_data[:tags].include?(tag)
          content_with_tag.push(meta_data)
        end
      end
      return content_with_tag
    else
      puts "You have not defined #{tag}"
      return []
    end
  end

  def get_path(path)
    content_with_path = []
    @content.each do |key, meta_data|
      puts meta_data[:path]
      if meta_data[:path].start_with?(path)
        content_with_path.push(meta_data)
      end
    end
    return content_with_path
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
          # TODO: Need cleanup way methods are passed
          @templates[path] = Template.new(template, meta_data, method(:get_tag),
                                          method(:get_tags),
                                          method(:get_path))
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
