require 'spec_helper'
include RequestHelpers

RSpec.feature "Event approval" do
    background do
		# currently not needed anymore..
    end

    before(:each) do
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_admin }

	#
	#
	scenario "Approve an unprocessed Event", :approval_of_unprocessed_event => true do
		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.driver.options[:respect_data_method] = false
		page.click_on("Genehmigen", :match => :first) # we are using own acceptance test seeds, otherwise selecting first would be a bad choice.
		page.visit "/events/1"
		page.should have_content("test_admin genehmigte das Event")
	end

	#
	#
	scenario "Reject an unprocessed Event", :reject_of_unprocessed_event => true do
  		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.click_on("Ablehnen", :match => :first)
		sleep 1
		have_text("Alternative")
		#page.find('a[class="btn btn-danger modal-decline-btn"]').click
		page.click_link "Ablehnen"
		have_text("Dashboard")
		#page.visit "/events/1"
		#page.should have_content("abgelehnt")
	end

    #currently in development as user story for Sprint 4, please uncomment for test	
	#
	#
	scenario "suggest an alternative for an unprocessed Event", :acceptance_test => true, js: true, exclude: true do
  		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.click_on("Ablehnen", :match => :first)
		sleep 1
		have_text("Alternative")
		page.find('a[class="btn btn-warning suggest-btn"]').click
		#page.click_on("Alternative vorschlagen", :match => :first)		
		page.click_link "Alternative vorschlagen"
		page.fill_in "event_ends_at_date", with: Date.tomorrow + 5
		page.fill_in "event_starts_at_date", with: Date.tomorrow + 5
		#save_and_open_page
		page.visit "/events/1"
		page.should have_content("test_admin genehmigte das Event")
	end

	# this feature is not supported anymore..
	#
	#
	scenario "View details for Room", :acceptance_test => true, exclude: true do
  		page.visit "/events_approval"
		page.click_link("A-1.1", :match => :first).click
		page.should have_content("A-1.1")
		page.should have_content("28")
	end

	#
	#
	scenario "View details for Event", :acceptance_test => true, :view_details_for_event => true do
  		page.visit "/events_approval"
		page.first(:link, "Klubtreffen").click
		page.should have_content("Klubtreffen des PR-Klubs")
	end
end
