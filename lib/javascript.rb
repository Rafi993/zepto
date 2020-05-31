require "uglifier"

class Javascript
  def initialize(javascript_path)
    @javascript_path = javascript_path
    @javascript = {}
  end

  def read(path)
    if File.file? path
      return File.read(path)
    else
      raise "File #{path} does not exist"
    end
  end

  def parse(path)
    file_content = read path
    return file_content
  end

  def minify(content)
    return Uglifier.compile(content, harmony: true)
  end

  def walk()
    for file in Dir[@javascript_path + "/**/*.js"]
      @javascript[file.sub(@javascript_path + "/", "").sub(".js", "").to_sym] = minify(parse(file))
    end
  end

  def compile()
    walk
    @javascript.each do |key, content|
      view_path = Pathname("dist/" + key.to_s.delete_prefix('"').delete_suffix('/"') + ".js")
      view_path.dirname.mkpath
      view_path.write(content)
    end
  end
end
