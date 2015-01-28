require 'rails_helper'
require "cancan/matchers"

describe "Rooms", :type => :request do

  before(:all) do
    @normal_user = FactoryGirl.create(:user) 
    @admin = FactoryGirl.create(:adminUser)
    @normal_user_ability = Ability.new(@normal_user)
    @admin_ability = Ability.new(@admin)
  end

  context "when user is not logged-in" do
    describe "GET /rooms" do
      it "should redirect to login" do
        get rooms_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  it "lets only admin users and those with permissions create and delete rooms" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("manage_rooms")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:create, :destroy]
    room = FactoryGirl.create(:room)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, room)
      expect(permitted_user_ability).to be_able_to(method, room)
      expect(@admin_ability).to be_able_to(method, room)
    }
  end

  it "lets only admin users and those with permissions update rooms" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("edit_rooms")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:update]
    room = FactoryGirl.create(:room)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, room)
      expect(permitted_user_ability).to be_able_to(method, room)
      expect(@admin_ability).to be_able_to(method, room)
    }
  end

  it "lets only admin users and those with permissions assign equipment and properties to rooms" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("assign_to_rooms")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:assign_equipment, :assign_properties]
    room = FactoryGirl.create(:room)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, room)
      expect(permitted_user_ability).to be_able_to(method, room)
      expect(@admin_ability).to be_able_to(method, room)
    }
  end

  it "lets only admin users and those with permissions approve and decline events for rooms" do 
    room = FactoryGirl.create(:room)
    another_room = FactoryGirl.create(:room)
    event = FactoryGirl.create(:event)
    event.rooms = [room]
    another_event = FactoryGirl.create(:event)
    another_event.rooms = [room, another_room]
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("approve_events")
    permitted_user_ability = Ability.new(permitted_user)
    another_permitted_user = FactoryGirl.create(:user)
    another_permitted_user.permit("approve_events", room)
    another_permitted_user_ability = Ability.new(another_permitted_user)
    methods = [:approve, :decline]
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, event)
      expect(permitted_user_ability).to be_able_to(method, event)
      expect(another_permitted_user_ability).to be_able_to(method, event)
      expect(@admin_ability).to be_able_to(method, event)
    }
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, another_event)
      expect(permitted_user_ability).to be_able_to(method, another_event)
      expect(another_permitted_user_ability).not_to be_able_to(method, another_event)
      expect(@admin_ability).to be_able_to(method, another_event)
    }
    expect(@normal_user_ability).not_to be_able_to(:approve_any, Event)
    expect(permitted_user_ability).to be_able_to(:approve_any, Event)
    expect(another_permitted_user_ability).to be_able_to(:approve_any, Event)
    expect(@admin_ability).to be_able_to(:approve_any, Event)
  end

end 
