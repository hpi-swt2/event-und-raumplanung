require 'spec_helper'

RSpec.feature "User signin" do 
	background do
		# @user = Factory(:user, :email => 'max.mustermann@student.hpi.uni-potsdam.de', :password => 'password')
	end

	scenario "Signing in with correct openID URL" do
		# @todo
		page.visit "/users/sign_in"
		page.fill_in "user_identity_url", :with => "https://openid.hpi.uni-potsdam.de/user/max.mustermann"
		page.click_button "Log in"
		expect(page.current_url).to eq "https://openid.hpi.uni-potsdam.de/serve"
	end
	
	scenario "Signing in with incorrect openID URL" do
		# @todo
		page.visit "/users/sign_in"
		page.fill_in "user_identity_url", :with => "test"
		page.click_button "Log in"
		page.should have_content("Ungültige Anmeldedaten.")
	end
end