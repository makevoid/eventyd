path = File.expand_path "../../", __FILE__

require "#{path}/lib/jsoner"

class FBError < RuntimeError
  def initialize(data)
    @data = data
  end

  def message
    "Facebook Error: #{@data["error"]["message"]}\nplease check your FB token in config - you can generate another key here: https://developers.facebook.com/tools/explorer"
  end
end

class Scraper

  include Jsoner

  def initialize(token, limit=5000)
    @token = token
    @limit = limit
  end

  def url(query)
   query = CGI.escape(query)
    "https://graph.facebook.com/search?type=event&q=#{query}&limit=#{@limit}&access_token=#{@token}"
  end

  def self.scrape(query, token, limit)
    new(token, limit).scrape(query)
  end

  def get(query)
    uri = URI(url(query))
    data = get_json(uri)
    raise FBError.new(data) if data["error"]
    data
  end

  def scrape(query)
    data = get query
    data = data["data"]
    events = []
    data.each do |event|
      events << {
        fb_id:      event["id"],
        name:       event["name"],
        starts_at:  event["start_time"],
        ends_at:    event["end_time"],
      }
    end if data
    puts "no datas for: #{query}" unless data
    events
  end

end