class Location
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   length: 255
  property :lat,        Float
  property :lng,        Float
  property :city,       String,   length: 255

  has n, :events

  before :create do
    self.name = self.name.capitalize if self.name
  end

  RANGE_DEFAULT = 2.0

  def self.search(lat, lng, range=Location::RANGE_DEFAULT)
    all :lat.lt => lat+range, :lat.gt => lat-range, :lng.lt => lng+range, :lng.gt => lng-range
  end

  def attributes_public
    attributes
  end

end