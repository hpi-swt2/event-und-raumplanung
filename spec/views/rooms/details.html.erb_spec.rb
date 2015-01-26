require 'rails_helper'

RSpec.describe "rooms/details.html.erb" do
    before(:all) do
        @default_locale = I18n.default_locale
    end
    
    after(:all) do
        I18n.default_locale = @default_locale
    end
    
    it "must run" do
		1.should == 1
	end
  
	it "must display the information of the room" do
		assign(:room, FactoryGirl.build(:room1))
		render
		expect(rendered).to include("HS1")
		expect(rendered).to include("30")
	end
	
	it "must display both equipment" do
		room = FactoryGirl.build(:room_with_equipment)
		assign(:room, room)
		render
		expect(rendered).to include("hpi")
		expect(rendered).to include("Beamer")
	end
	
	it "must display the equipment information" do
		room = FactoryGirl.build(:room_with_equipment)
		assign(:room, room)
		render
		expect(rendered).to include(room.equipment.first.name)
		expect(rendered).to include(room.equipment.last.name)
		expect(rendered).to include(room.equipment.first.description)
		expect(rendered).to include(room.equipment.last.description)
	end
    
    #context "uses locales to show both German and English" do
   
        #it "shows English" do    
        #   assign(:room,FactoryGirl.build(:room1))
        #    I18n.default_locale = :en
        #    render
        #    expect(rendered).to include('Equipment')
        #end
        
        #it "shows German" do    
        #    assign(:room,FactoryGirl.build(:room1))
        #    I18n.default_locale = :de
        #    render
        #    expect(rendered).to include('Ausstattung')
        #end
    #end

end