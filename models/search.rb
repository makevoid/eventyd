class Search

  def search(location)
    key = Keyword.first :name.like => location
    key.events
    # TODO: calls geolocation api and mix results

    # Geo.search

  end

end