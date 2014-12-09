require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(name:"Test3",participant_count:2,starts_at:Date.new, ends_at:Date.new))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do
    end
  end
end
