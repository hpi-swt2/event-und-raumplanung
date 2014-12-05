require 'rails_helper'

RSpec.describe Group, :type => :model do
  it "has a valid factory" do
    factory = FactoryGirl.build(:group)
    expect(factory).to be_valid
  end
end
