require 'rails_helper'

RSpec.describe "events/index", :type => :view do
#doesn't work with filterific
=begin
  let(:user) { create :user }
  before(:each) do
  	 @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    assign(:events, [
      Event.create!(
	name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at:Date.new('2020-08-23'),
    ends_at:Date.new('2020-08-23'),
    user_id: user.id
      ),
      Event.create!(
	name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at:Date.new('2020-08-23'),
    ends_at:Date.new('2020-08-23'),
    user_id: user.id
      )
    ])
    @filterrific = Filterrific.new(Event);
  end

  it "renders a list of events" do
  end 
=end

end
