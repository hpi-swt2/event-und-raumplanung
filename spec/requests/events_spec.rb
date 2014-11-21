require 'rails_helper'
require "cancan/matchers"

RSpec.describe "Events", :type => :request do

  context "when user is not logged-in" do
    describe "GET /events" do
      it "should redirect to login" do
        get events_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end
end
