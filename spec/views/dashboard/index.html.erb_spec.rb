require 'rails_helper'

RSpec.describe "dashboard/index", :type => :view do
  let(:user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    visit '/'
    6.times { |i| FactoryGirl.create(:upcoming_event, name: i.to_s) }
  end

  describe "Events partial" do
    it "renders the event overview" do
      page.should have_content('Eventname1')
      page.should have_content('Eventname2')
    end
  end
end