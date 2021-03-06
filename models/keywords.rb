class Keyword
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, length: 100

  has n, :events
end