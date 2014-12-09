require 'spec_helper'
include RequestHelpers

RSpec.feature "Event approval" do
    background do
	    @user = FactoryGirl.create :user, email: 'jack@daniels.com'
    end

    before(:each) do
	    page.set_rack_session(:user_id => @user.id) 
	    load Rails.root + "db/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_user }

	scenario "Approve an unprocessed Event" do	
  		page.visit "/event_approval"
		#page.click_button "Approve"
		#page.find_field("Approve").click		
		page.find_link("Approve").click		
		page.should have_content("Successfully added.")
		puts page.body
	end

	scenario "Reject an unprocessed Event" do
  		page.visit "/event_approval"
		#page.click_button "Reject"
		page.find("btn-success btn-xs").first.click
		page.should have_content("Successfully rejected.")
		puts page.body
	end

	scenario "View details for Room" do
  		page.visit "/event_approval"
		#page.find('a', :text => "room").click
		page.find_link("room").click	
		page.should have_content("Anstehende Events")
	end

	scenario "View details for Event" do
  		page.visit "/event_approval"
		page.find_link("Tribute von Panem").click
		page.should have_content("Details zum Event Tribute von Panem 2015")
	end
end

