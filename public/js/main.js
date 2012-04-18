(function() {
  var in_event_page;

  in_event_page = function() {
    var path;
    path = location.pathname.split("/");
    return path && path.length === 3 && path[1] === "events";
  };

  if (in_event_page()) {
    $(function() {
      var event_id;
      event_id = $(".event").data("event");
      return $.get("/events/" + event_id + "/details", function(data) {
        var map, mapDiv, marker, position, view;
        console.log(data);
        view = "";
        if (data.place) {
          view += "  <div class='place'>place: " + data.place + "</div>          ";
        }
        if (data.venue_id) {
          view += "  <div class='venue'><div id='gmap'></div></div>          ";
        }
        if (data.owner) {
          view += "    <div class='owner'>published by: " + data.owner + "</div>            ";
        }
        view += "    <div class='desc'>" + data.description + "</div>";
        if (data.updated_at) {
          view += "<div class='updated_at'>last updated: " + data.updated_at + "</div>        ";
        }
        $(".details").html(view);
        mapDiv = document.getElementById('gmap');
        position = new google.maps.LatLng(data.lat, data.lng);
        map = new google.maps.Map(mapDiv, {
          center: position,
          zoom: 12,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        return marker = new google.maps.Marker({
          position: position,
          map: map,
          title: data.place || data.name
        });
      });
    });
  }

}).call(this);
