require "rails_helper"

RSpec.describe EventsApprovalController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/events_approval").to route_to("events_approval#index")
    end

  end
end
