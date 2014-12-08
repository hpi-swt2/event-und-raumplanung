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
    other_user = build(:user, :id => 2)
    ability = Ability.new(user)
    methods = [:edit, :update, :destroy]
    own_event = build(:event, :user_id => 1)
    other_event = build(:event, :user_id => 2)
    methods.each { |method| 
	  expect(ability).to be_able_to(method, own_event)
	  expect(ability).to_not be_able_to(method, other_event)
    }
  end

  it "only admin users can approve and decline events" do
    normal_user = build(:user) 
    admin = FactoryGirl.build(:admin_user)
    normal_user_ability = Ability.new(normal_user)
    admin_ability = Ability.new(admin)
    methods = [:approve, :decline]
    event = build(:event)
    methods.each { |method| 
      expect(admin_ability).to be_able_to(method, event)
      expect(normal_user_ability).not_to be_able_to(method, event)
    }
  end

end 
