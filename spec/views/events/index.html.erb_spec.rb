require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      Event.create!(name:"Test",participant_count:2),
      Event.create!(name:"Test2",participant_count:2)
    ])
  end

  it "renders a list of events" do
    render
  end
end
