require 'rails_helper'

RSpec.describe "Groups", :type => :request do
  describe "GET /groups" do
    context "when user is not logged-in" do
            
      it "redirect to login path" do
        get groups_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
