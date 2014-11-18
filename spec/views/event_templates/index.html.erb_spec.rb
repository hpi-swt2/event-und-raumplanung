require 'rails_helper'

RSpec.describe "event_templates/index", :type => :view do
  before(:each) do
    assign(:event_templates, [
      EventTemplate.create!(),
      EventTemplate.create!()
    ])
  end

  it "renders a list of event_templates" do
    render
  end
end
