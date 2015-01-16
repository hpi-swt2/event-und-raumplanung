require "rails_helper"

RSpec.describe EventsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/events").to route_to("events#index")
    end

    it "routes to #new" do
      expect(:get => "/events/new").to route_to("events#new")
    end

    it "routes to #show" do
      expect(:get => "/events/1").to route_to("events#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/events/1/edit").to route_to("events#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/events").to route_to("events#create")
    end

    it "routes to #update" do
      expect(:put => "/events/1").to route_to("events#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/events/1").to route_to("events#destroy", :id => "1")
    end

    it "routes to #new_event_template" do
      expect(:get => "/events/1/new_event_template").to route_to("events#new_event_template", :id => "1")
    end

    it "routes to #approve and #decline" do
      expect(:post => "/events/1/approve").to route_to("events#approve", :id => "1")
      expect(:get => "/events/1/decline").to route_to("events#decline", :id => "1")
    end

  end
end
