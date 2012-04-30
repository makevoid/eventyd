path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :default

require "date"
require "#{path}/lib/ruby_exts"

# setup:
#
# mysql -u root -e "CREATE DATABASE IF NOT EXISTS eventyd_development;"

env = ENV["RACK_ENV"] || "development"

DataMapper.setup :default, "mysql://root@localhost/eventyd_#{env}"

Dir.glob("models/*.rb").each do |model|
  require "#{path}/#{model}"
end
DataMapper.finalize


# irb -r ./config/env.rb
# DataMapper.auto_migrate!

# ruby -r ./config/env.rb -e 'DataMapper.auto_migrate!'