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

  def fetch(key)
    visited = []
    key.split('.').inject(@entries) do |hash, part|
      unless hash.kind_of?(Hash)
        raise TypeError, "config entry %s is a %p, not a Hash" \
          % [format_key_parts(visited), hash.class]
      end
      hash.fetch(part) {
        raise IndexError, "config entry not found: %s" \
          % format_key_parts(visited + [part])
      }.tap {
        visited << part
      }
    end
  end

  def path(key)
    path = fetch(key).sub('~', Dir.home)
    return path if path =~ %r[^/]
    [@base_dir, path].join('/')
  end

private

  def format_key_parts(parts)
    if parts.empty?
      "[root]"
    else
      parts.join "."
    end
  end
end
