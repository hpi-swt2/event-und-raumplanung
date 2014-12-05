require 'session_helpers'
require 'spec_helper'

feature "Event" do
	background do
    end

	scenario "create a new Event" do
		# @todo
  		page.visit "/events"
		page.fill_in "user_identity_url", :with =&gt; "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Create"
		page.should have_content("Successfully added.")
	end
end
