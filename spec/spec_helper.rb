path = File.expand_path "../../", __FILE__
PATH = path unless defined?(PATH)

ENV["RACK_ENV"] = "test"

require "#{path}/lib/getter"

DataMapper.auto_migrate!

def clear_db
  DataMapper.auto_migrate!
end