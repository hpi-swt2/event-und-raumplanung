require 'session_helpers'
require 'spec_helper'

feature "Event approval" do
	background do
    end

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

