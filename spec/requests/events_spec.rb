require 'rails_helper'
require "cancan/matchers"

RSpec.describe "Events", :type => :request do

  context "when user is not logged-in" do
    describe "GET /events" do
      it "should redirect to login" do
        get events_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  it "lets only the event creator edit, update and delete his events" do 
  	user = build(:user, :id => 1)
    ability = Ability.new(user)
    methods = [:edit, :update, :destroy]
    own_event = build(:event, :user_id => 1)
    other_event = build(:event, :user_id => 2)
    methods.each { |method| 
	   expect(ability).to be_able_to(method, own_event)
	    expect(ability).to_not be_able_to(method, other_event)
    }
  end

  it "only admin users and those with permissions can approve and decline events" do
    normal_user = FactoryGirl.create(:user) 
    permitted_user = FactoryGirl.create(:user)
    another_permitted_user = FactoryGirl.create(:user)
    a_room = FactoryGirl.create(:room)
    permitted_user.permit("approve_events")
    admin = FactoryGirl.create(:adminUser)
    normal_user_ability = Ability.new(normal_user)
    permitted_user_ability = Ability.new(permitted_user)    
    another_permitted_user_ability = Ability.new(another_permitted_user)
    admin_ability = Ability.new(admin)
    methods = [:approve, :decline]
    event = FactoryGirl.create(:event)
    another_event = FactoryGirl.create(:event)
    another_event.rooms = [a_room]
    another_permitted_user.permit("approve_events", a_room)
    methods.each { |method| 
      expect(admin_ability).to be_able_to(method, event)
      expect(normal_user_ability).not_to be_able_to(method, event)
      expect(permitted_user_ability).to be_able_to(method, event)
      expect(another_permitted_user_ability).not_to be_able_to(method, event)
    }
    methods.each { |method| 
      expect(admin_ability).to be_able_to(method, another_event)
      expect(normal_user_ability).not_to be_able_to(method, another_event)
      expect(permitted_user_ability).to be_able_to(method, another_event)
      expect(another_permitted_user_ability).to be_able_to(method, another_event)
    }
  end

  it "lets only event creator approve and decline suggestions for the original event" do 
    user = build(:user, :id => 1)
    ability = Ability.new(user)
    methods = [:approve_event_suggestion, :decline_event_suggestion]
    own_event = build(:event, :user_id => 1)
    other_event = build(:event, :user_id => 2)
    methods.each { |method| 
      expect(ability).to be_able_to(method, own_event)
      expect(ability).to_not be_able_to(method, other_event)
    }
  end
end 
