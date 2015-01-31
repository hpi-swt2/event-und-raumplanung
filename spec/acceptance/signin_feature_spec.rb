require 'spec_helper'

RSpec.feature "User signin" do 

<<-DOC  # to be examined
  	#
    	#
	scenario "Signing in with single button", :user_signin_correct => true do
		page.visit "/users/sign_in"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/openidlogin"
	end

  	#
    	#
	scenario "Signing in with single button and new admin login", :user_signin_correct => true do
		page.visit "/admin"
		page.should have_text("Admin Login")
		page.fill_in "email", :with => "test_admin@example.com"
		page.fill_in "encrypted_password", :with => "test_admin"
		page.click_button "Log in"
		page.should have_content("Dashboard")
	end
DOC

<<-DOC	# OLD TESTS: not necessary anymore due to change in login process
  	#
    	#
	scenario "Signing in with correct eMail", :user_signin_correct => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "Max.Mustermann@student.hpi.de"
		page.click_button "Log in"
		#expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/"
		expect(page.current_url).to eq "http://www.example.com/users/sign_in"
	end
	#
    	#
	scenario "Signing in with incorrect eMail", :user_signin_incorrect => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test"
		page.click_button "Log in"
		page.should have_content("Bitte benutze eine gültige HPI E-Mail Adresse")
	end

  	#
    	#
	scenario "Signing in admin eMail", :user_signin_admin => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_email", :with => "test_admin@example.com"
		page.click_button "Log in"
		page.fill_in "user_encrypted_password", :with => "test_admin"
		page.click_button "Log in"
		page.should have_content("Erfolgreich angemeldet")
	end

  	#
    	#
	scenario "Signing in with simple button", :user_signin_single_button => true do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end

  	#
    	#
	scenario "Signing in with correct openID URL" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_identity_url", :with => "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end

  	#
    	#
	scenario "Signing in with incorrect openID URL" do
		page.visit "/users/sign_in"
		page.should have_text("Log in")
		page.fill_in "user_identity_url", :with => "test"
		page.click_button "Log in"
		page.should have_content("Ungültige Anmeldedaten.")
	end
DOC

end
