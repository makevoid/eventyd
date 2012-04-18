path = File.expand_path "../", __FILE__
PATH = path

require "#{path}/config/env"

class Eventyd < Sinatra::Application
  set :root, PATH

  include Voidtools::Sinatra::ViewHelpers

  configure :development do
    use Rack::Reloader, 0
    Sinatra::Application.reset!
  end

  LIMIT = 30

  def all_events
    Event.future.limited
  end

  get "/" do
    @events = all_events
    haml :index
  end

  get "/events" do
    @events = all_events
    haml :index
  end

  NamedStruct = Struct.new(:name)

  post "/events" do
    @keyword = Keyword.first :name.like => params[:location]
    @events = if @keyword
      @keyword.events.future.limited
    else
      @keyword = NamedStruct.new params[:location]
      []
    end
    haml :index
  end

  get "/events/:id/details" do |id|
    @event = Event.get id
    @event.fill_details
    content_type :json

    @event.details
  end

  get "/events/*" do |id|
    @event = Event.first name_url: id
    halt 404, "Not Found" unless @event
    haml :event
  end


end