Tr = { # Translations
  default: "eng"
  eng:
    months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  ita:
    months: ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
    
  tr: this[this.default]
}

EventsApp = {
  events: []
  markers: []
  map: null
  infowin: new google.maps.InfoWindow
  # locations: []
}

class Location
  constructor: ->

class Event
  constructor: ->
    
  

page_home = ->
  path = location.pathname.split("/")
  path && (path.length == 3 && path[1] == "home") || location.pathname == "/" || location.pathname == ""

page_event = ->
  path = location.pathname.split("/")
  path && path.length == 3 && path[1] == "events"


get_location = ->
  navigator.geolocation.getCurrentPosition(got_location)

got_location = (loc) ->
  loc.gmaps_position = new google.maps.LatLng loc.coords.latitude, 
  loc.coords.longitude
  gmap_location(loc)
  
gmap_location = (loc) ->
  map = gmap(loc.gmaps_position)
  $.getJSON "/events/coords/#{loc.coords.latitude}/#{loc.coords.longitude}", (events) ->
    for event in events
      EventsApp.events.push event
      
    set_markers(map)
    




popup = (event) ->
  view = ""
  view += "<h1>#{event.name}</h1>"
  view += "<div class='location'>#{event.location.name}</div>"
  date = event.starts_at
  date = new Date(date)
  starts_at = "#{date.getDate()} #{Tr.ita.months[date.getMonth()]}"
  view += "<div class='starts_at'>#{starts_at}</div>"
  view += "<div class='description'>#{event.description}</div>"

set_markers = (map) ->
  EventsApp.map = map
  for event in EventsApp.events
    position = new google.maps.LatLng event.location.lat, event.location.lng
    marker = new google.maps.Marker
      position: position, 
      map: map, 
      title: event.name
    event.marker = marker
  set_info_windows()
  
set_info_windows = -> 
  for event in EventsApp.events
    google.maps.event.addListener event.marker, 'click', (position)  -> 
      window_open(position)
      
      
window_open = (position) ->
  event = _(EventsApp.events).find (ev) ->
    ev if ev.marker.position == position.latLng
  map = EventsApp.map
  
  view = popup(event)
  win = EventsApp.infowin
  win.setPosition map.getCenter()
  win.setContent view     
  win.open(map, event.marker)
  
    
gmap = (position) ->
  mapDiv = document.getElementById('gmap')
  new google.maps.Map mapDiv, {
    center: position,
    zoom: 11,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false
  }

#if page_home()  
$ -> 
  get_location()

if page_event()
  $ ->
  
    event_id = $(".event").data("event")
    $.get "/events/#{event_id}/details", (data) ->
      data = JSON.parse(data)
      
      # view
      view = ""
      view += "
  <div class='place'>place: #{data.place}</div>" if data.place
      
      if data.venue_id
        view += "
  <div class='venue'><div id='gmap'></div></div>" 

      view += "
    <div class='owner'>published by: #{data.owner}</div>        
    " if data.owner
      view += "
    <div class='desc'>#{data.description}</div>"
      view += "
<div class='updated_at'>last updated: #{data.updated_at}</div>" if data.updated_at
        
        
      $(".details").html view
      
      position = new google.maps.LatLng data.lat, data.lng
      map = gmap(position)
      
      marker = new google.maps.Marker({
          position: position, 
          map: map,
          title: data.place || data.name
      })
