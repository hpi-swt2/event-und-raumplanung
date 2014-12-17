require 'rails_helper'

RSpec.describe "Events_approval", :type => :request do

  context "when user is not logged-in" do
    describe "GET /events_approval" do
      it "should redirect to login" do
        get events_approval_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  
end 
