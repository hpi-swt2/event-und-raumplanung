require 'rails_helper'

describe RoomsController do

	before(:each) do
		@user = create(:user)
		@request.env["devise.mapping"] = Devise.mappings[:user]
		sign_in @user
	end
	
	it "must run must accept an HTTP Request" do
			get :index
			expect(response).to be_success
			expect(response).to have_http_status(200)

	end

end