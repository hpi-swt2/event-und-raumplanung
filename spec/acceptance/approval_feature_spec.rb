require 'spec_helper'
include RequestHelpers

RSpec.feature "Event approval" do
    background do
	    #@admin = FactoryGirl.create(:adminUser)
    end

    before(:each) do
	    #page.set_rack_session(:user_id => @admin.id) 
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_admin }

	scenario "Approve an unprocessed Event", :approval_of_unprocessed_event => true do
		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.driver.options[:respect_data_method] = false
		page.click_on("Genehmigen", :match => :first) # we are using own acceptance test seeds, otherwise selecting first would be a bad choice.
		page.visit "/events/1"
		page.should have_content("bestätigt")
	end

	scenario "Reject an unprocessed Event", :reject_of_unprocessed_event => true do
  		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.driver.options[:respect_data_method] = false
		page.click_on("Ablehnen", :match => :first)
		sleep 1
		have_text("Alternative")
		page.find('a[class="btn btn-danger modal-decline-btn"]').click
		page.visit "/events/1"
		page.should have_content("abgelehnt")
	end
	
	scenario "suggest an alternative for an unprocessed Event", :suggest_alternative_for_unprocessed_event => true do
  		page.visit "/events_approval"
		have_text("Klubtreffen des PR-Klubs")
		have_text("Klubtreffen")
		page.driver.options[:respect_data_method] = false
		page.click_on("Ablehnen", :match => :first)
		sleep 1
		have_text("Alternative")
		save_and_open_page
		#page.find('a[class="btn btn-warning suggest-btn"]').click
		page.click_on("Alternative vorschlagen", :match => :first)		
		page.fill_in "event_ends_at_date", with: Date.tomorrow + 5
		page.fill_in "event_starts_at_date", with: Date.tomorrow + 5
		#save_and_open_page
		page.visit "/events/1"
		page.should have_content("bestätigt")
	end

<<-DOC	
	scenario "View details for Room" do
  		page.visit "/events_approval"
		page.click_link("A-1.1", :match => :first).click
		page.should have_content("A-1.1")
		page.should have_content("28")
	end
DOC
	scenario "View details for Event", :view_details_for_event => true do
  		page.visit "/events_approval"
		page.first(:link, "Klubtreffen").click
		page.should have_content("Klubtreffen des PR-Klubs")
	end
end
