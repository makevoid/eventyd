require_relative "spec_helper"

require "#{PATH}/eventyd"

describe Eventyd do
  it "GET /" do
    get "/"
    body.should =~ /Eventyd/
  end

  it "GET /events/1" do
    Event.create name: "RailsBerry"
    get "/events/1"
    body.should =~ /RailsBerry/
  end
end