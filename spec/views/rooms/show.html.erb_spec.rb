require 'rails_helper'

RSpec.describe "rooms/show.html.erb" do

  before(:each) do
    assign(:room, FactoryGirl.create(:room))
    assign(:events, [])
  end

  it "displays no equipment assigned" do
    assign(:assigned_equipment, {})
    render
    expect(rendered).to include('Keine Ausstattung vorhanden')
  end
  
  it "displays assigned equipment" do
    assign(:assigned_equipment, {'Beamer'=> 2})
    render
    expect(rendered).to include('Beamer')
  end

end
