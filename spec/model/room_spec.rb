require_relative '../../app/models/room'
require 'spec_helper'

describe Room do
	
	it "must run and must correctly use the factory" do
    @room1 = FactoryGirl.build(:room1)
    @room1.name.should == ("HS1")
	@room1.size.should == (30)
  end
end