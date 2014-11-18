require 'rails_helper'

RSpec.describe "event_templates/edit", :type => :view do
  before(:each) do
    @event_template = assign(:event_template, EventTemplate.create!())
  end

  it "renders the edit event_template form" do
    render

    assert_select "form[action=?][method=?]", event_template_path(@event_template), "post" do
    end
  end
end
