require 'rails_helper'

RSpec.describe "events/_chosen_rooms.html.erb" do
      
#  before(:each) do
#  end
  
  it "shows room names" do
    rooms = [FactoryGirl.build(:room, name: 'Raum 1' )]
    assign(:chosen_rooms, rooms)
    assign(:available_equipment, {})
    render
    expect(rendered).to include('Raum 1')
  end
  
  it "shows nothing if no rooms are chosen" do 
    assign(:chosen_rooms, nil)
    render
    expect(rendered).to be_empty
  end
  
  it "shows all available equipment categories" do
    room = FactoryGirl.build(:room)
    rooms = [room]
    available_equipment = [FactoryGirl.build(:equipment, category: 'Beamer')]
    assign(:chosen_rooms, rooms)
    assign(:available_equipment, available_equipment)
    assign(:room_equipment, {room.id => {}})
    render
    expect(rendered).to include('Beamer')
  end
  
end
