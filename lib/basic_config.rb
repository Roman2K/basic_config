require 'json'

class BasicConfig
  def initialize(path)
    if File.directory? path
      @dir = path
      file = path + '/main.json'
    else
      file = path
    end
    @entries = JSON.parse(File.read(file))
    @base_dir = File.dirname(path)
  end

  attr_reader :entries

  def dir
    @dir or raise "path was given as a file, not a dir"
  end

  def path(key)
    path = @entries.fetch(key).sub('~', Dir.home)
    return path if path =~ %r[^/]
    [@base_dir, path].join('/')
  end
end
