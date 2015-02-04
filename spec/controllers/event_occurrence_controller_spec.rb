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

    it "succeeds if event has schedule" do
      weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event, :user_id => user.id)
      get :show, {:eventid => weekly_recurring_event.to_param, :starting => weekly_recurring_event.starts_at.advance(week: 1).to_s, :ending => weekly_recurring_event.ends_at.advance(week: 1).to_s}
      expect(response).to be_success
      expect(assigns(:event_occurrence)).to be_a(EventOccurrence)
    end

    it "only shows tasks assigned to current user when he is not the event owner" do
      assigned_user = create(:user)
      sign_in assigned_user

      event = FactoryGirl.create(:weekly_recurring_event, user_id: user.id)
      firstTask = create(:task, event_id: event.id, identity: assigned_user)
      secondTask = create(:task, event_id: event.id)

      get :show, {:eventid => event.to_param, :starting => event.starts_at.advance(week: 1).to_s, :ending => event.ends_at.advance(week: 1).to_s}
      expect(assigns(:tasks)).to eq [firstTask]
    end
  end

  describe "delete occurrence" do
    context "and is allowed to delete this event" do
      it "and successfully deletes an occurrence" do
        weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event, :user_id => user.id)
        delete :destroy, {:eventid => weekly_recurring_event.to_param, :starting => weekly_recurring_event.starts_at.advance(week: 1).to_s, :ending => weekly_recurring_event.ends_at.advance(week: 1).to_s}
        expect(response).to redirect_to(root_path)
      end
    end

    context "and is not allowed to delete this event" do
      it "and gets an error when trying deletes an occurrence" do
        weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event)
        expect {
          delete :destroy, {:eventid => weekly_recurring_event.to_param, starting: weekly_recurring_event.starts_at.advance(weeks: 1), ending: weekly_recurring_event.ends_at.advance(weeks: 1)}
        }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
