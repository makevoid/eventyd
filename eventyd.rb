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

  def days_week
    @days = (Date.today..(Date.today+7)).to_a
  end

  def all_events
    days_week
    @events = Event.future.limited
  end

  # events

  get "/" do
    all_events
    haml :index
  end

  get "/events" do
    all_events
    haml :index
  end

  NamedStruct = Struct.new(:name)

  post "/events" do
    @keyword = Keyword.first :name.like => params[:location]
    days_week
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

  get "/events/coords/:lat/:lng" do |lat, lng|
    @events = Event.search(lat.to_f, lng.to_f)
    content_type :json
    @events.map{ |event| event.attributes_public }.to_json
  end

  get "/events/*" do |id|
    @event = Event.first name_url: id
    halt 404, "Not Found" unless @event
    haml :event
  end




end