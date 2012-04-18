require_relative "spec_helper"

require "#{PATH}/eventyd"

describe Eventyd do

  it "GET /" do
    get "/"
    body.should =~ /Eventyd/
  end

  it "GET /events/1" do
    location = Location.create name: "Krakow"
    event = location.events.create name: "RailsBerry"
    get "/events/#{event.id}"
    body.should =~ /RailsBerry/
  end

  after :all do
    clear_db
  end

end