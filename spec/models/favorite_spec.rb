require 'rails_helper'

RSpec.describe Favorite, :type => :model do
  it "has a valid factory" do
    factory = FactoryGirl.build(:favorite)
    expect(factory).to be_valid
  end
end
