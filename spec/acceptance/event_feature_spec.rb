require 'spec_helper'
# include RequestHelpers

RSpec.feature "Event" do
	include Devise::TestHelpers
	# background do
		# @user = FactoryGirl.create :user, email: 'jack@daniels.com'
    # end

    let(:user) { create :user }
    
    before(:each) do
	    # @request.env["devise.mapping"] = Devise.mappings[:user]
	    sign_in user
  	end

    # let!(:authed_user) { create_logged_in_user }

	scenario "create a new Event" do
		# @todo
		# page.set_rack_session(:user_id => @user.id)
  		page.visit "/events"
  		# page.click_link "Neu"
  		page.click_button "Log in"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		# page.fill_in "event_name", with: ""
		# page.fill_in "event_name", with: ""
		# page.fill_in "event_name", with: ""
		# page.fill_in "event_name", with: ""
		page.click_button "Event erstellen"
		page.should have_content("Successfully added.")
	end
end
