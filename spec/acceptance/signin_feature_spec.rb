require 'spec_helper'

RSpec.feature "User signin" do 

	scenario "Signing in with correct eMail", :user_signin_correct => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "Max.Mustermann@student.hpi.de"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/"
	end

	scenario "Signing in with incorrect eMail", :user_signin_incorrect => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test"
		page.click_button "Log in"
		page.should have_content("Bitte benutze eine gültige HPI E-Mail Adresse")
	end

	scenario "Signing in admin eMail", :user_signin_admin => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test_admin@example.com"
		page.click_button "Log in"
		page.fill_in "user_encrypted_password", :with => "test_admin"
		page.click_button "Log in"
		page.should have_content("Erfolgreich angemeldet")
	end

<<-DOC	
	scenario "Signing in with simple button", :user_signin_single_button => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end

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
