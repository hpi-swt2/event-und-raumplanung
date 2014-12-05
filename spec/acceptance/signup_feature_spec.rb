require 'spec_helper'

feature "User signup" do 
	background do
		@user = Factory(:user, :email =&gt; 'max.mustermann@student.hpi.uni-potsdam.de', :password =&gt; 'password')
	end

	scenario "Signing in with correct openID URL" do
		# @todo
		page.visit "/users/sign_in"
		page.fill_in "user_identity_url", :with =&gt; "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Log in"
		page.should have_content("Log in with your HPI account to get started.")
	end
	
	scenario "Signing in with incorrect openID URL" do
		# @todo
		page.visit "/users/sign_in"
		page.fill_in "user_identity_url", :with =&gt; "test"
		page.click_button "Log in"
		page.should have_content("Ungültige Anmeldedaten.")
	end
end