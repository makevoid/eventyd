require_relative "spec_helper"

require "#{PATH}/eventyd"

describe Eventyd do

  it "GET /" do
    get "/"
    body.should =~ /Eventyd/
  end

  it "GET /events/:id" do
    location = Location.create name: "Krakow"
    keyword = Keyword.create name: "krakow"
    event = location.events.create name: "RailsBerry", keyword_id: keyword.id
    get "/events/#{event.name_url}"
    body.should =~ /RailsBerry/
  end

  after :all do
    clear_db
  end

end