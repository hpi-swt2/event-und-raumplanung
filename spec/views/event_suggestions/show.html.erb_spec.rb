require 'rails_helper'

RSpec.describe "event_suggestions/show", :type => :view do
  before(:each) do
    @event_suggestion = assign(:event_suggestion, FactoryGirl.create(:event_suggestion))
  end

  # it "renders attributes in <p>" do
  #   render
  #   expect(rendered).to match(/Starts At/)
  #   expect(rendered).to match(/Ends At/)
  #   expect(rendered).to match(/Status/)
  #   expect(rendered).to match(/1/)
  # end
end
