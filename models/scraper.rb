class FBError < RuntimeError
  def initialize(data)
    @data = data
  end

  def message
    "Facebook Error: #{@data["error"]["message"]}\nplease check your FB token in config - you can generate another key here: https://developers.facebook.com/tools/explorer"
  end
end

class Scraper

  def initialize(token, limit=5000)
    @token = token
    @limit = limit
  end

  def url(query)
    "https://graph.facebook.com/search?q=#{query}&limit=#{@limit}&type=event&access_token=#{@token}"
  end

  def self.scrape(query, token, limit)
    new(token, limit).scrape(query)
  end

  def get(query)
    uri = URI(url(query))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    data = JSON.parse response.body
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