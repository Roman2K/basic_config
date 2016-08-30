$:.unshift __dir__ + '/../lib'

require 'minitest/autorun'
require 'json'
require 'basic_config'

class BasicConfigTest < Minitest::Test
  def test_fetch
    config = make_config \
      "foo" => "bar",
      "a" => {
        "b" => "myval"
      }

    assert_equal "bar", config.fetch("foo")
    assert_equal "myval", config.fetch("a.b")

    exc = assert_raises TypeError do
      config.fetch("foo.mykey")
    end
    assert_match(/entry foo is a String/, exc.message)

    exc = assert_raises IndexError do
      config.fetch("a.mykey")
    end
    assert_match(/not found: a.mykey/, exc.message)

    config = make_config []
    exc = assert_raises TypeError do
      config.fetch("mykey")
    end
    assert_match(/entry \[root\] is a Array/, exc.message)
  end

  def make_config(entries)
    file = Tempfile.new "basic_config"
    file.write JSON.dump(entries)
    file.close
    begin
      config = BasicConfig.new file.path
    ensure
      file.delete
    end
    config
  end
end
