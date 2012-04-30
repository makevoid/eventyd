path = File.expand_path "../../", __FILE__

require "#{path}/lib/jsoner"

class Event
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String,   length: 255
  property :name_url,     String,   length: 255#, unique: true
  property :fb_id,        String,   unique: true
  property :image,        String,   length: 255
  property :description,  Text
  property :starts_at,    DateTime
  property :ends_at,      DateTime
  property :location_id,  Integer, required: false
  property :keyword_id,   Integer, required: false

  belongs_to :location
  belongs_to :keyword

  before :create do
    self.name_url = self.name.urlize
  end

  default_scope(:default).update( :order => [:starts_at] )

  def self.no_location
    all(location_id: nil)
  end

  def self.future
    all(:starts_at.gt => Time.now)
  end

  def self.next_week
    all(:starts_at.gt => Date.today, :starts_at.lt => Date.today+7)
  end

  def self.search(lat, lng, range=Location::RANGE_DEFAULT)
    locations = Location.search(lat, lng, range)
    Event.all(location: locations)
  end

  def self.day(day)
    all(:starts_at.gt => day.to_time, :starts_at.lt => day+1)
  end

  LIMIT = 30
  def self.limited
    all(limit: LIMIT)
  end

  def attributes_public
    attributes.merge(location: location.attributes, keyword: keyword).merge(description: description_short())
  end

  def description_short(chars=200)
    if description
      description.size >= chars ? "#{description}..." : description
    end
  end

  # TODO: done like this (ajax) for hackaton, later save them in the database

  def details
    @details.to_json
  end

  include Jsoner

  def fill_details
    uri = URI.parse "https://graph.facebook.com/#{self.fb_id}"
    details = get_json(uri)
    @details = {}
    @details[:name] = self.name
    @details[:description] = details["description"]
    @details[:updated_at] = details["updated_time"]
    @details[:owner] = details["owner"]["name"] if details["owner"]
    @details[:place] = details["location"]
    if details["venue"]
      @details[:venue_id] = details["venue"]["id"]
      @details[:lat] = details["venue"]["latitude"]
      @details[:lng] = details["venue"]["longitude"]
    end
    @details
  rescue JSON::ParserError
    @details = {}
  end

end