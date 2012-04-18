class Event

  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   length: 255
  property :fb_id,      String,   unique: true
  property :starts_at,  DateTime
  property :ends_at,    DateTime

end