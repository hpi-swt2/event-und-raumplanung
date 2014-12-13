require 'spec_helper'

RSpec.feature "User signin" do 

	scenario "Signing in with correct eMail" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "Max.Mustermann@student.hpi.de"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end

	scenario "Signing in with incorrect eMail" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test"
		page.click_button "Log in"
		page.should have_content("Inkorrekte E-mail Adresse.")
	end

	scenario "Signing in admin eMail" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test.admin@admin.hpi.de"
		page.click_button "Log in"
		page.fill_in "user_encrypted_password", :with => "test_admin"
		page.click_button "Log in"
		page.should have_content("Willkommen test.admin!")
	end

<<-DOC	
	scenario "Signing in with correct openID URL" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_identity_url", :with => "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end

	scenario "Signing in with incorrect openID URL" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_identity_url", :with => "test"
		page.click_button "Log in"
		page.should have_content("Ungültige Anmeldedaten.")
	end
DOC

end
