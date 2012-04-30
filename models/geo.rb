class Geo
  def search(place)
    # returns locations
    limit = 30
    lat, lng = geo(place)
    range = 1.0
    Location.search(lat, lng, range)
  end

  URL = "https://maps.googleapis.com/maps/api/geocode/json?address=firenze+riotvan&sensor=true"

  private

  def geo(place)
    # TODO: implement geolocation

    [lat, lng]
  end
end