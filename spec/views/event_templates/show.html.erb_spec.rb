require 'rails_helper'

RSpec.describe "event_templates/show", :type => :view do
  before(:each) do
    @event_template = assign(:event_template, FactoryGirl.create(:event_template))
  end
end
