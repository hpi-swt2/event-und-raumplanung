require 'rails_helper'

RSpec.describe "event_templates/new", :type => :view do
  before(:each) do
    assign(:event_template, EventTemplate.new())
  end

  it "renders new event_template form" do
    render

    assert_select "form[action=?][method=?]", event_templates_path, "post" do
    end
  end
end
