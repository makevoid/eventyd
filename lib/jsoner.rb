
require 'net/https'
require "json"

module Jsoner
  def get_json(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    JSON.parse response.body
  end
end