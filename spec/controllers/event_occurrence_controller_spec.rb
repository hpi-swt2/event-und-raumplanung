require 'rails_helper'

RSpec.describe EventOccurrenceController, :type => :controller do
  include Devise::TestHelpers

  let(:user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET show" do

    it "throws Not Found if event has no schedule" do
      event = FactoryGirl.create(:event)
      expect {
        get :show, {:eventid => event.to_param}.merge(FactoryGirl.attributes_for(:event_occurrence))
      }.to raise_error(ActionController::RoutingError)
    end

    it "throws Not Found if event has schedule, but occurrence doesn't match the schedule" do
      weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event)
      expect {
        get :show, {:eventid => weekly_recurring_event.to_param}.merge(FactoryGirl.attributes_for(:event_occurrence))
      }.to raise_error(ActionController::RoutingError)
    end

    it "throws Not Found if event has no schedule" do
      pending("throws Not Found")
      weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event, :user_id => user.id)
      get :show, {:eventid => weekly_recurring_event.to_param}.merge(FactoryGirl.attributes_for(:event_occurrence_for_weekly_event1))
      expect(response).to be_success
      expect(assigns(:event_occurrence)).to be_a(EventOccurrence)
    end
  end
end
