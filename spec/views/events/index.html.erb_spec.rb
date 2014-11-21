require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      FactoryGirl.create(:event),
      FactoryGirl.create(:event)
    ])
  end

  it "renders a list of events" do
    render
  end
end
