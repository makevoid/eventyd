class Event
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   length: 255
  property :name_url,   String,   length: 255
  property :fb_id,      String,   unique: true
  property :starts_at,  DateTime
  property :ends_at,    DateTime

  belongs_to :location

  before :create do
    self.name_url = self.name.urlize
  end

end