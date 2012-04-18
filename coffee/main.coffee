in_event_page = ->
  path = location.pathname.split("/")
  path && path.length == 3 && path[1] == "events"


if in_event_page()
  $ ->
  
    event_id = $(".event").data("event")
    $.get "/events/#{event_id}/details", (data) ->
      data = JSON.parse(data)
      view = ""
      view += "
  <div class='place'>place: #{data.place}</div>        
  " if data.place
      
      if data.venue_id
        view += "
  <div class='venue'><div id='gmap'></div></div>        
  " 

        
      view += "
    <div class='owner'>published by: #{data.owner}</div>        
    " if data.owner
      view += "
    <div class='desc'>#{data.description}</div>"
      view += "
<div class='updated_at'>last updated: #{data.updated_at}</div>        
" if data.updated_at
        
      $(".details").html view
      
      mapDiv = document.getElementById('gmap')
      position = new google.maps.LatLng data.lat, data.lng
      map = new google.maps.Map mapDiv, {
        center: position,
        zoom: 12,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      }
    
      marker = new google.maps.Marker({
          position: position, 
          map: map,
          title: data.place || data.name
      });