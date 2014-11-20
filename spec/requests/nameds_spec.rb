require 'rails_helper'

RSpec.describe "Nameds", :type => :request do
  describe "GET /events" do
    it "works! " do
      get "events"
      expect(response.status).to be(200)
    end
  end
  describe "GET /templates" do
    it "works! " do
      get "templates"
      expect(response.status).to be(200)
    end
  end
end
