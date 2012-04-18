class Event
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   length: 255
  property :name_url,   String,   length: 255#, unique: true
  property :fb_id,      String,   unique: true
  property :starts_at,  DateTime
  property :ends_at,    DateTime

  belongs_to :location
  belongs_to :keyword

  before :create do
    self.name_url = self.name.urlize
  end

  default_scope(:default).update( :order => [:starts_at] )

  def self.future
    all(:starts_at.gt => Time.now)
  end

  LIMIT = 30
  def self.limited
    all(limit: LIMIT)
  end

  # TODO: done like this (ajax) for hackaton, later save them in the database

  def details
    @details.to_json
  end

  include Jsoner

  def fill_details
    uri = URI.parse "https://graph.facebook.com/#{self.fb_id}"
    get_json(uri)
  end

end