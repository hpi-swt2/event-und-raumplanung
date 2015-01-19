require 'rails_helper'
require "cancan/matchers"

describe "RoomProperties", :type => :request do

  before(:all) do
    @normal_user = FactoryGirl.create(:user) 
    @admin = FactoryGirl.create(:adminUser)
    @normal_user_ability = Ability.new(@normal_user)
    @admin_ability = Ability.new(@admin)
  end

  it "lets only admin users and those with permissions create and delete roomproperties" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("manage_properties")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:create, :destroy]
    room_property = FactoryGirl.create(:room_property)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, room_property)
      expect(permitted_user_ability).to be_able_to(method, room_property)
      expect(@admin_ability).to be_able_to(method, room_property)
    }
  end

  it "lets only admin users and those with permissions update roomproperties" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("edit_properties")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:update]
    room_property = FactoryGirl.create(:room_property)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, room_property)
      expect(permitted_user_ability).to be_able_to(method, room_property)
      expect(@admin_ability).to be_able_to(method, room_property)
    }
  end

end 
