class Location
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   length: 255
  property :lat,       Float
  property :lng,       Float

  has n, :events

  before :create do
    self.name = self.name.capitalize
  end

  def self.none
    @@none ||= Location.first(name: "none") || Location.create(name: "none")
  end

end