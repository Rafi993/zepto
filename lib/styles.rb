class Styles
  def initialize(styles_path)
    @styles_path = styles_path
    @styles = {}
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
    return content.gsub(/\s+/, "")
  end

  def walk()
    for file in Dir[@styles_path + "/**/*.css"]
      @styles[file.sub(@styles_path + "/", "").sub(".css", "").to_sym] = minify(parse(file))
    end
  end

  def compile()
    walk
    @styles.each do |key, content|
      view_path = Pathname("dist/" + key.to_s.delete_prefix('"').delete_suffix('/"') + ".css")
      view_path.dirname.mkpath
      view_path.write(content)
    end
  end
end
