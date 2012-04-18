path = File.expand_path "../", __FILE__
PATH = path

require "#{path}/config/env"

class Eventyd < Sinatra::Application
  set :root, PATH

  configure :development do
    use Rack::Reloader, 0
    Sinatra::Application.reset!
  end

  get "/" do
    @location = "Krakow"
    @events = Event.all
    haml :index
  end

  get "/events" do
    @events = Event.all
    haml :index
  end

  post "/events" do
    @location = Location.first params[:location]
    @events = @location.events
    haml :index
  end

  get "/events/:id" do |id|
    @event = Event.get id
    haml :event
  end

end