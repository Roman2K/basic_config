# BasicConfig

A parent class for a config class reading its values from a JSON file.

## Usage

Example `config.json`:
```
{
  "port": 8080,
  "db": "mongodb://localhost:27017/my_app")",
  "log": "my_app.log",
  "priv_key": "~/.keys/priv"
}
```

Example class:

```ruby
class Config < BasicConfig
  def init_db
    Mongo::MongoClient.from_uri(entries.fetch('db')).db
  end

  def init_log
    Logger.new(path('log'))
  end
end

# Setup:
config = Config.new('config.json')

# Reading values:
port = config.entries.fetch('port') # => 8080

# Reading path values from (expands ~):
priv_key = config.path('priv_key')  # => "/home/roman/.keys/priv"

# Custom methods:
db = config.init_db
log = config.init_log
```

Instead of a JSON file, a directory can be passed, in which case values are read
from `<dir>/main.json`:

```ruby
config = Config.new('path/to/config/dir')

# Same usage:
config.entries.fetch('port') 

# But access to a `dir` method:
data_dir = config.dir + "/data"
```
