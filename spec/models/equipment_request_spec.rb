require_relative '../../app/models/equipment_request'
require 'rails_helper'

RSpec.describe EquipmentRequest, :type => :model do
  it "has a valid factory" do
    factory = FactoryGirl.build(:equipment_request)
    expect(factory).to be_valid
  end
end
