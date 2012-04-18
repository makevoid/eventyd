in_event_page = ->
  path = location.pathname.split("/")
  path && path.length == 3 && path[1] == "events"


if in_event_page()
  $ ->
  
    event_id = $(".event").data("event")
    $.get "/events/#{event_id}/details", (data) ->
      console.log data
  