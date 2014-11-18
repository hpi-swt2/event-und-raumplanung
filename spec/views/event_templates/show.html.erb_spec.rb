require 'rails_helper'

RSpec.describe "event_templates/show", :type => :view do
  before(:each) do
    @event_template = assign(:event_template, EventTemplate.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
