require "spec_helper"

require "rack/test"

def app
  Eventyd
end
include Rack::Test::Methods

enable :sessions


def body
  last_response.body
end

def referer
  location = last_response.headers["Location"]
  location.gsub(/http:\/\/example\.org/, '') if location
end