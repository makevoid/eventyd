class Geo
  def search(place)
    # returns locations
    limit = 30
    lat, lng = geo(place)
    range = 1.0
    Location.all :lat.lt => lat+range, :lat.gt => lat-range, :lng.lt => lng+range, :lng.gt => lng-range, limit: limit
  end

  URL = "https://maps.googleapis.com/maps/api/geocode/json?address=firenze+riotvan&sensor=true"

  private

  def geo(place)
    # TODO: implement geolocation

    [lat, lng]
  end
end