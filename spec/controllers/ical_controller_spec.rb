require 'rails_helper'

RSpec.describe IcalController, :type => :controller do
  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user, icaltoken: 'myawesometoken' }
  let(:event) { FactoryGirl.create :event, user_id: user.id }
  let(:weekly_recurring_event) { FactoryGirl.create(:weekly_recurring_event, :user_id => user.id) }
  let(:weekly_recurring_event_ending) { FactoryGirl.create :weekly_recurring_event_ending, user_id: user.id }


  describe "GET get" do
    it "redirects to root_path when invalid token is given" do
      get :get, icaltoken: 'invalid token'
      expect(response).to redirect_to(root_path)
    end

    it "responds with recurring events created by the user" do
      user
      weekly_recurring_event_ending
      get :get, icaltoken: 'myawesometoken'
      expect(response).to be_success
      expect(assigns(:cal).events).not_to be_empty
    end

    it "responds with recurring events and limits them to one year created by the user" do
      user
      weekly_recurring_event
      get :get, icaltoken: 'myawesometoken'
      expect(response).to be_success
      expect(assigns(:cal).events).not_to be_empty
    end

    it "responds with events created by the user" do
      user
      event
      get :get, icaltoken: 'myawesometoken'
      expect(response).to be_success
      expect(assigns(:cal).events).not_to be_empty
    end

    it "responds with empty ical for a user with no events" do
      user
      get :get, icaltoken: 'myawesometoken'
      expect(response).to be_success
      expect(assigns(:cal).events).to be_empty
    end

  end
end
