require 'rails_helper'

RSpec.describe "rooms/list.html.erb" do
  it "must run" do
    1.should == 1
  end

  it "must display no selection message" do
      assign(:noSelection, true)
      assign(:categories, Array.new)
      assign(:properties, Array.new)
      assign(:empty, false)
      assign(:rooms, Array.new)
      render
      expect(rendered).to include(I18n.t('rooms.list.no_selection'))
  end

  it "must display no Rooms found message" do
    assign(:noSelection, false)
    assign(:categories, Array.new)
    assign(:properties, Array.new)
    assign(:empty, true)
    assign(:rooms, Array.new)
    render
    expect(rendered).to include(I18n.t('rooms.list.no_rooms_found'))
  end

  it "must display a room" do
    room = FactoryGirl.build(:room)
    assign(:noSelection, false)
    assign(:categories, Array.new)
    assign(:properties, Array.new)
    assign(:empty, false)
    assign(:rooms, [room])
    render
    expect(rendered).to include(room.name)
    expect(rendered).to include(room.size.to_s)
  end

  it "must display a room with equipment" do
    equipment = [FactoryGirl.build(:wlan).name, FactoryGirl.build(:beamer).name]
    properties = [FactoryGirl.build(:room_property1).name, FactoryGirl.build(:room_property2).name]
    assign(:noSelection, false)
    assign(:categories, equipment)
    assign(:properties, properties)
    assign(:empty, false)
    assign(:rooms, Array.new)
    render
    expect(rendered).to include(equipment.first)
    expect(rendered).to include(equipment.last)
    expect(rendered).to include(properties.first)
    expect(rendered).to include(properties.last)
  end

end