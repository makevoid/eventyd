# Eventyd
### Find all FB events in your city

api used:

- Facebook: "https://graph.facebook.com/search?type=event&q=QUERY&..."
- Google Maps: "https://maps.googleapis.com/maps/api/geocode/json?address=QUERY&sensor=false"

### to start:

create a mysql database:

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS eventyd_development;"


if you need, edit config/env.rb if you have different mysql user/pass than root//(nopass)


run migrations:

    ruby -e 'DataMapper.auto_migrate!' -r ./config/env


bundle then

    rackup

also see: /lib/getter.rb


it's simple and useful, so join me/us!


### specs: 

create a mysql database for test env:

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS eventyd_test;"

run specs:

    rspec



### pastebin:



https://graph.facebook.com/search?q=conference&limit=5000&type=event&access_token=AAAAAAITEghMBAGefQGr18NKdcREGbIwyvylFVlN3eGiTGcROxwQdsQrKKtefyWMh92ZB0JiWwZBIVbTfiXbxtu7q1QUAGJd4rhWZAZBCnZAYTFZAomZCfpP

https://graph.facebook.com/search?type=place&center=11.2569013,43.7687324&distance=150&limit=10&access_token=AAAEvWkjm0wQBAL70Occqh9kZBPWXqKpZAXVpLnic6BWtW6AlkYonhQc7s4tk2kaSS9hLAIZBIqvkg9nSZCPB5cOXFiRbqh1ZB7f3osN9vR5GcYJRLJUut

fb api
event: https://developers.facebook.com/docs/reference/api/event/

api explorer: https://developers.facebook.com/tools/explorer/333539793359620/?method=GET&path=1218562195

google maps
http://maps.google.com/maps?q=43.763130187988,11.28843688964

geolocation api
http://dev.w3.org/geo/api/spec-source.html
https://developers.google.com/maps/documentation/geocoding/

http://open.mapquestapi.com/nominatim/
http://open.mapquestapi.com/nominatim/v1/search?format=json&json_callback=renderBasicSearchNarrative&q=firenze