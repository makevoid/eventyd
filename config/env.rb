path = File.expand_path "../../", __FILE__

require 'bundler/setup'
Bundler.require :default

# setup:
#
# mysql -u root -e "CREATE DATABASE IF NOT EXISTS eventyd_development;"

DataMapper.setup :default, "mysql://root@localhost/eventyd_development"

Dir.glob("models/*.rb").each do |model|
  require "#{path}/#{model}"
end
DataMapper.finalize


# irb -r ./config/env.rb
# DataMapper.auto_migrate!

# ruby -r ./config/env.rb -e 'DataMapper.auto_migrate!'