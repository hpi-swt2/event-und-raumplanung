require "rails_helper"

RSpec.describe EventSuggestionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/event_suggestions").to route_to("event_suggestions#index")
    end

    it "routes to #new" do
      expect(:get => "/event_suggestions/new").to route_to("event_suggestions#new")
    end

    it "routes to #show" do
      expect(:get => "/event_suggestions/1").to route_to("event_suggestions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/event_suggestions/1/edit").to route_to("event_suggestions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/event_suggestions").to route_to("event_suggestions#create")
    end

    it "routes to #update" do
      expect(:put => "/event_suggestions/1").to route_to("event_suggestions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/event_suggestions/1").to route_to("event_suggestions#destroy", :id => "1")
    end

  end
end
