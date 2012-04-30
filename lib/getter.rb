path = File.expand_path "../../", __FILE__

require "#{path}/config/env"

class EventNotSaved < RuntimeError

end

class Getter

  attr_reader :configs, :words

  def initialize(file)
    @configs  = load_configs file
    @token    = @configs[:token]
    @words    = @configs[:words][:cities] + @configs[:words][:types] + @configs[:words][:places]
  end

  def load_configs(file)
    # evil! yeah >:
    eval File.read(file)
  end

  def get
    @words.each do |query|
      scrape query
    end
  end

  def scrape(query)
    limit = 10 if ENV["RACK_ENV"] == "test"
    events = Scraper.scrape query, @token, limit
    events.each do |event|
      begin
        keyword = Keyword.first name: query
        keyword = Keyword.create name: query unless keyword
        event = Event.new event.merge(keyword_id: keyword.id)
        unless event.save
          raise EventNotSaved, "Error saving the event: #{event.errors.inspect}"
        end
      rescue DataObjects::IntegrityError
        print "d"
      end
    end
  end


end

# ruby lib/get.rb