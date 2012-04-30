path = File.expand_path "../../", __FILE__

require "#{path}/lib/getter_location"

puts "getting some events... (this may take some minutes)"
getter = GetterLocation.new
getter.get
puts "\ngot them!"