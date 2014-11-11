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
end

RSpec.describe "Events", :type => :request do 
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
end 
