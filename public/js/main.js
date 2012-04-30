(function() {
  var Event, EventsApp, Location, Tr, get_location, gmap, gmap_location, got_location, page_event, page_home, popup, set_info_windows, set_markers, window_open;

  Tr = {
    "default": "eng",
    eng: {
      months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    },
    ita: {
      months: ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
    },
    tr: this[this["default"]]
  };

  EventsApp = {
    events: [],
    markers: [],
    map: null,
    infowin: new google.maps.InfoWindow
  };

  Location = (function() {

    function Location() {}

    return Location;

  })();

  Event = (function() {

    function Event() {}

    return Event;

  })();

  page_home = function() {
    var path;
    path = location.pathname.split("/");
    return path && (path.length === 3 && path[1] === "home") || location.pathname === "/" || location.pathname === "";
  };

  page_event = function() {
    var path;
    path = location.pathname.split("/");
    return path && path.length === 3 && path[1] === "events";
  };

  get_location = function() {
    return navigator.geolocation.getCurrentPosition(got_location);
  };

  got_location = function(loc) {
    loc.gmaps_position = new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude);
    return gmap_location(loc);
  };

  gmap_location = function(loc) {
    var map;
    map = gmap(loc.gmaps_position);
    return $.getJSON("/events/coords/" + loc.coords.latitude + "/" + loc.coords.longitude, function(events) {
      var event, _i, _len;
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        event = events[_i];
        EventsApp.events.push(event);
      }
      return set_markers(map);
    });
  };

  popup = function(event) {
    var date, starts_at, view;
    view = "";
    view += "<h1>" + event.name + "</h1>";
    view += "<div class='location'>" + event.location.name + "</div>";
    date = event.starts_at;
    date = new Date(date);
    starts_at = "" + (date.getDate()) + " " + Tr.ita.months[date.getMonth()];
    view += "<div class='starts_at'>" + starts_at + "</div>";
    return view += "<div class='description'>" + event.description + "</div>";
  };

  set_markers = function(map) {
    var event, marker, position, _i, _len, _ref;
    EventsApp.map = map;
    _ref = EventsApp.events;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      event = _ref[_i];
      position = new google.maps.LatLng(event.location.lat, event.location.lng);
      marker = new google.maps.Marker({
        position: position,
        map: map,
        title: event.name
      });
      event.marker = marker;
    }
    return set_info_windows();
  };

  set_info_windows = function() {
    var event, _i, _len, _ref, _results;
    _ref = EventsApp.events;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      event = _ref[_i];
      _results.push(google.maps.event.addListener(event.marker, 'click', function(position) {
        return window_open(position);
      }));
    }
    return _results;
  };

  window_open = function(position) {
    var event, map, view, win;
    event = _(EventsApp.events).find(function(ev) {
      if (ev.marker.position === position.latLng) return ev;
    });
    map = EventsApp.map;
    view = popup(event);
    win = EventsApp.infowin;
    win.setPosition(map.getCenter());
    win.setContent(view);
    return win.open(map, event.marker);
  };

  gmap = function(position) {
    var mapDiv;
    mapDiv = document.getElementById('gmap');
    return new google.maps.Map(mapDiv, {
      center: position,
      zoom: 11,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false
    });
  };

  $(function() {
    return get_location();
  });

  if (page_event()) {
    $(function() {
      var event_id;
      event_id = $(".event").data("event");
      return $.get("/events/" + event_id + "/details", function(data) {
        var map, marker, position, view;
        data = JSON.parse(data);
        view = "";
        if (data.place) {
          view += "  <div class='place'>place: " + data.place + "</div>";
        }
        if (data.venue_id) {
          view += "  <div class='venue'><div id='gmap'></div></div>";
        }
        if (data.owner) {
          view += "    <div class='owner'>published by: " + data.owner + "</div>            ";
        }
        view += "    <div class='desc'>" + data.description + "</div>";
        if (data.updated_at) {
          view += "<div class='updated_at'>last updated: " + data.updated_at + "</div>";
        }
        $(".details").html(view);
        position = new google.maps.LatLng(data.lat, data.lng);
        map = gmap(position);
        return marker = new google.maps.Marker({
          position: position,
          map: map,
          title: data.place || data.name
        });
      });
    });
  }

}).call(this);
