require 'spec_helper'

RSpec.feature "User signin" do 

	scenario "Signing in with correct openID URL" do
		page.visit "/users/sign_in"
		have_text("Log in")
		page.fill_in "user_identity_url", :with => "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end
	
	scenario "Signing in with incorrect openID URL" do
		page.visit "/users/sign_in"
		have_text("Log in")
		page.fill_in "user_identity_url", :with => "test"
		page.click_button "Log in"
		page.should have_content("Ungültige Anmeldedaten.")
	end
end
