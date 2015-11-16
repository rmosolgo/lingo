require "../spec_helper"

describe "RoadNames" do
  it "finds interstate" do
    RoadNames.parse_road("I-95").interstate.should eq(true)
    RoadNames.parse_road("101").interstate.should eq(false)
  end

  it "finds numbers" do
    RoadNames.parse_road("I-95N").number.should eq(95)
  end

  it "finds direction" do
    RoadNames.parse_road("64W").direction.should eq("W")
    RoadNames.parse_road("50").direction.should eq(nil)
  end

  it "finds business" do
    RoadNames.parse_road("250B").business.should eq(true)
    RoadNames.parse_road("250").business.should eq(false)
  end
end
