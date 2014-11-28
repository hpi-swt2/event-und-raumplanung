require 'rails_helper'
require "cancan/matchers"

RSpec.describe "EventsTemplates", :type => :request do

  context "when user is not logged-in" do
    describe "GET /EventsTemplates" do
      it "should redirect to login" do
        get event_templates_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end
end

RSpec.describe "EventsTemplates", :type => :request do 
  it "lets only the event_template creator edit, update and delete his EventsTemplates" do 
  	user = build(:user, :id => 1)
    other_user = build(:user, :id => 2)
    ability = Ability.new(user)
    methods = [:edit, :update, :destroy]
    own_event_template = build(:event_template, :user_id => 1)
    other_event_template = build(:event_template, :user_id => 2)
    methods.each { |method| 
	  expect(ability).to be_able_to(method, own_event_template)
	  expect(ability).to_not be_able_to(method, other_event_template)
    }
  end 
end 
