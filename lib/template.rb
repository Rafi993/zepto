require "erb"
require "pathname"

class Template
  def initialize(template, meta_data)
    @template = template
    # Setting all the metadata keys as instance variables
    meta_data.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def render
    puts @title
    renderer = ERB.new(@template)
    @html = renderer.result(binding)
  end

  def write
    view_path = Pathname("dist" + @path.delete_prefix('"').delete_suffix('/"') + ".html")
    view_path.dirname.mkpath
    view_path.write(@html)
  end
end
