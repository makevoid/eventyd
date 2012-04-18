path = File.expand_path "../../", __FILE__

require "#{path}/lib/getter"

puts "getting some events... (this may take some minutes)"
getter = Getter.new "#{path}/config/config.rb"
getter.get
puts "\ngot them!"