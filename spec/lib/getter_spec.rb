require "spec_helper"


describe Getter do

  let(:getter){ Getter.new "#{PATH}/spec/config.test.rb" }

  it "should load configs" do
    getter.configs[:token].should be_a(String)
  end

  context "with network" do
    it "should get events from FB" do
      getter.get
      Event.all.should_not == []
    end
  end

end