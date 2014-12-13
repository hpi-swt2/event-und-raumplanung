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
		page.visit "/events_approval"
		have_text("Event request processing")
		have_text("Sommerfest")
		page.driver.options[:respect_data_method] = false
		page.click_on("Approve", :match => :first) 
		#page.first(:link, "Approve").click
		page.should have_content("Event has been successfully approved.")		
	end

	scenario "Reject an unprocessed Event" do
  		page.visit "/events_approval"
		have_text("Event request processing")
		have_text("Sommerfest")
		page.first(:link, "Decline").click		
		page.should have_content("Event has been successfully rejected.")
		puts page.body
	end

	scenario "View details for Room" do
  		page.visit "/events_approval"
		page.click_link("room", :match => :first).click
		page.should have_content("Raum")
		page.should have_content("Keine speziellen Eigenschaften")
	end

	scenario "View details for Event" do
  		page.visit "/events_approval"
		page.first(:link, "Sommerfest").click
		page.should have_content("Event")
		page.should have_content("Details zur Sommerfest 2015")
	end
end

