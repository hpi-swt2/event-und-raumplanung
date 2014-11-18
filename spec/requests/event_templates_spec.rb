require 'rails_helper'

RSpec.describe "EventTemplates", :type => :request do
  describe "GET /event_templates" do
    it "works! (now write some real specs)" do
      get event_templates_path
      expect(response).to have_http_status(200)
    end
  end
end
