require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  let(:user) { create :user }

  before(:each) do
  	 @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    assign(:events, [
      Event.create!(
	name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    start_date:'2020-08-23',
    end_date:'2020-08-23',
    start_time:'17:00',
    end_time:'23:59',
    user_id: user.id
      ),
      Event.create!(
	name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    start_date:'2020-08-23',
    end_date:'2020-08-23',
    start_time:'17:00',
    end_time:'23:59',
    user_id: user.id
      )
    ])
    @filterrific = Filterrific.new(Event);
  end

  it "renders a list of events" do
  end
end
