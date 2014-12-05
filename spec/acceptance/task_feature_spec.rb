require 'session_helpers'
require 'spec_helper'

feature "Task" do
	background do
    end

	scenario "create Task" do
		# @todo
  		page.visit "/tasks"
		page.click_button "approve"
		page.should have_content("Successfully added.")
	end

	scenario "Reject an unprocessed Event" do
		# @todo
  		page.visit "/tasks"
		page.click_button "reject"
		page.should have_content("Successfully rejected.")
	end
end
