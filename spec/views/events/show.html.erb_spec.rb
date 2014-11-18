require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(name:"Test3",participant_count:2))
  end

  it "renders attributes in <p>" do
    render
  end
end
