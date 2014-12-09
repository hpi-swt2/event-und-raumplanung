require 'spec_helper'
include RequestHelpers

feature "Event approval" do
    background do
	    @user = FactoryGirl.create :user, email: 'jack@daniels.com'
    end

    before(:each) do
	    page.set_rack_session(:user_id => @user.id) 
	    load Rails.root + "db/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_user }

	scenario "Approve an unprocessed Event" do
		# @todo		
  		page.visit "/event_approval"
		page.click_button "approve"
		page.should have_content("Successfully added.")
	end

	scenario "Reject an unprocessed Event" do
		# @todo
  		page.visit "/event_approval"
		page.click_button "reject"
		page.should have_content("Successfully rejected.")
	end
end

