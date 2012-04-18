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
        return console.log(data);
      });
    });
  }

}).call(this);
