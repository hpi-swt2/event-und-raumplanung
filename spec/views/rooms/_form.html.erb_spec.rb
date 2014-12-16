require 'rails_helper'

RSpec.describe "rooms/_form.html.erb" do
      
  before(:each) do
    assign(:room, FactoryGirl.build(:room))
    assign(:assigned_equipment, {})
    assign(:available_equipment, {})
    assign(:properties, [])
  end
  
  it "shows equipment" do
    assign(:assigned_equipment, {'Beamer' => 1})
    assign(:available_equipment, {'Beamer' => 2, 'Toaster' => 1})
    render
    expect(rendered).to include('Beamer')
    expect(rendered).to include('Toaster')
  end
  
end
