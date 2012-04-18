path = File.expand_path "../../", __FILE__

require 'net/https'
require "json"

require "#{path}/config/env"

TOKEN = "AAACEdEose0cBAFfhQRKdQnj7rG8MBBKWaJZCZBallmBITZCAmyBygkPV5JeLpLbvgVYdDYBNssJpZAWGIjMyTFZCNgxYmNNfR0gKB1QIlCNnJcZBYDoCeX"

def scrape(query)
  events = Scraper.scrape query, TOKEN
  events.each do |event|
    begin
      Event.create event
    rescue DataObjects::IntegrityError
      print "d"
    end
  end
end

# english

cities = ["krakow", "amsterdam", "firenze", "roma"]
types = ["conference", "concert", "event", "party", "afterparty"]
places = ["park", "museum", "office", "square"]

# italian

# cities = ["krakow", "firenze", "roma", "bologna", "milano", "napoli"]
# types = ["conference", "concerto", "mostra", "proiezione", "film", "festa", "festival", "cinema"]
# places = ["parco", "museo", "galleria", "teatro", "campo", "chiesa", "piazza"]


DataMapper.auto_migrate!

queries = cities + types + places + objects + letters
queries.each do |query|
  scrape query
end


# ruby lib/get.rb