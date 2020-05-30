require "erb"

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
    renderer.result(binding)
  end
end
