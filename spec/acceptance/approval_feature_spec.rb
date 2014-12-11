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
<<-DOC  
	scenario "Approve an unprocessed Event" do
		page.visit "/events_approval"
		have_text("EventsApproval#index")
		have_text("Sommerfest")
		#page.click_button "Approve"
		#page.find_field("Approve").click		
		#page.find_link("Approve").click
		#page.find('a[data-method="approve"]').first(:link, "Approve").click
		#page.find('a[class="btn btn-success btn-xs"]').click	
		#page.click_link("Approve", :match => :first)	
		#page.find('a[href="/events/2/decline?date=2014-12-10/"').click
		#page.find('a[data-method="approve"]').both.click
		#within 'a[data-method="approve"]' do
		#	firt(:link, "Approve").click
		#end
		#page.driver.headers = { 'ACCEPT-LANGUAGE' => 'en' }
		page.first(:link, "Approve").click
		page.should have_content("Successfully added.")		
	end


	scenario "Reject an unprocessed Event" do
  		page.visit "/events_approval"
		#page.click_button "Reject"
		#page.find("btn-success btn-xs").first.click
		page.first(:link, "Decline").click		
		page.should have_content("Successfully rejected.")
		puts page.body
	end


	scenario "View details for Room" do
  		page.visit "/events_approval"
		page.click_link("room", :match => :first).click
		#page.find_link("room").click	
		page.should have_content("Raum")
		page.should have_content("Keine speziellen Eigenschaften")
	end
DOC

	scenario "View details for Event" do
  		page.visit "/events_approval"
		page.first(:link, "Sommerfest").click
		page.should have_content("Event")
		page.should have_content("Details zur Sommerfest 2015")
	end

end

