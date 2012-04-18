path = File.expand_path "../../", __FILE__

require 'net/https'
require "json"

require "#{path}/config/env"

class Getter

  TOKEN = "AAAEvWkjm0wQBAEQNGG4dGYiElFVcpxPMorK5HnFGzEZC28RoncEPwzipa1QnUWdvMwZApR1wpTnIc3G8IPPtfuNIMOW8IHGVC3lr2atUZATFqd5z0Y6"

  def get
    # english
    #
    cities = ["krakow", "amsterdam", "firenze", "roma"]
    types = ["conference", "concert", "event", "party", "afterparty"]
    places = ["park", "museum", "office", "square"]

    # italian
    #
    # cities = ["krakow", "firenze", "roma", "bologna", "milano", "napoli"]
    # types = ["conference", "concerto", "mostra", "proiezione", "film", "festa", "festival", "cinema"]
    # places = ["parco", "museo", "galleria", "teatro", "campo", "chiesa", "piazza"]

    # temporary
    DataMapper.auto_migrate!

    queries = cities + types + places
    queries.each do |query|
      scrape query
    end
  end

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


end

# ruby lib/get.rb