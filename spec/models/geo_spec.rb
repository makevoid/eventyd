require "spec_helper"

describe Geo do
  let(:geo) { Geo.new }

  pending "should geolocate" do
    geo.send(:geo, "krakow").should == []
  end

end