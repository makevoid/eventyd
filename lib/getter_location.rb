path = File.expand_path "../../", __FILE__

require "#{path}/config/env"

class KAGetter # KeepAliveGetter => https://gist.github.com/1298812
  attr_reader :uri

  def initialize(host, protocol=nil)
    prot = protocol || "http"
    url = "#{prot}://#{host}"
    @uri = URI.parse url
  end

  def start(&block)
    Net::HTTP.start(@uri.host, @uri.port) do |http|
      @http = http
      block.call(self)
    end
  end

  def get(path)
    resp = @http.get path
    resp.body
  end

end


class GetterLocation

  def initialize
    @events = Event.no_location
  end

  def get
    kag = KAGetter.new "graph.facebook.com"
    @events.each do |event|
      get_location kag, event
    end
  end

  def get_location(kag, event)
    kag.start do |g|
      resp = g.get "/#{event.fb_id}"
      p resp
      unless resp == "false"
        resp = JSON.parse resp
        venue = resp["venue"] || {}
        loc = {
          name: resp["location"],
          lat: venue["latitude"],
          lng: venue["longitude"],
          city: resp["city"]
        }
        unless event.location
          loca = Location.find name: loc[:name]
          loca = Location.create loc
          event.location_id = loca.id
          event.description = resp["description"]
          cover = resp["cover"]
          event.image = cover["source"] if cover
          event.save!
        end
      end
    end
  end

end