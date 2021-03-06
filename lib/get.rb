path = File.expand_path "../../", __FILE__

require "#{path}/lib/getter"
require "#{path}/lib/getter_location"

DataMapper.auto_migrate!

puts "getting some events... (this may take some minutes)"
getter = Getter.new "#{path}/config/config.rb"
getter.get


puts "getting some locations..."
getter = GetterLocation.new
getter.get
puts "\ngot them!"