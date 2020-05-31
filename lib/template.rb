require "erb"
require "pathname"

class Template
  def initialize(template, meta_data, get_tag, get_tags)
    @template = template
    define_singleton_method(:get_tag) do |tag|
      get_tag.call(tag)
    end

    define_singleton_method(:get_tags) do
      get_tags.call
    end

    # Setting all the metadata keys as instance variables
    meta_data.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def render()
    renderer = ERB.new(@template)
    @html = renderer.result(binding)
  end

  def write
    view_path = Pathname("dist/" + @path.delete_prefix('"').delete_suffix('/"') + ".html")
    view_path.dirname.mkpath
    view_path.write(@html)
  end
end
