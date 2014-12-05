require 'rails_helper'
require 'cancan/matchers'

RSpec.describe DashboardController, type: :controller do
  include Devise::TestHelpers

  let(:valid_session) { }
  let(:user) { create :user }

  let(:valid_attributes) {{
    name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    is_private: true,
    user_id: user.id
  }}

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns upcoming event to @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:events)).to eq([event])
    end

    it "assigns max 5 upcoming events as @events" do
      6.times { |i| FactoryGirl.create(:upcoming_event, name: i.to_s) }
      get :index, {}, valid_session
      expect(assigns(:events).size).to eq(5)
    end
  end
end