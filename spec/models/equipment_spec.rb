require_relative '../../app/models/equipment'
require 'spec_helper'

describe Equipment do  
  
  before(:all) do
	 	@correct_equipment = FactoryGirl.create(:correct_equipment)
	end

	it "has a valid factory" do
   	factory = FactoryGirl.build(:correct_equipment)
   	expect(factory).to be_valid
  end

  it "is valid with a name and category" do
   	@equipment = FactoryGirl.build(:correct_equipment)
   	@equipment.name.should == "Beamer HD 1" and @equipment.category.should == "Beamer"
  end

	it "belongs to a room" do
		t = Equipment.reflect_on_association(:room)
   	t.macro.should == :belongs_to
	end

  it 'is invalid without name or category'do
	  @equipment = FactoryGirl.build(:incorrect_equipment1)
	  expect(@equipment).not_to be_valid

	  @equipment = FactoryGirl.build(:incorrect_equipment2)
    expect(@equipment).not_to be_valid
	end

	it 'should return equipments for a name' do
   	results = Equipment.equipment_name(@correct_equipment.name)
   	expect(results).to include(@correct_equipment)
   	results = Equipment.equipment_name(@correct_equipment.name[0])
   	expect(results).to include(@correct_equipment)
   	results = Equipment.equipment_name(@correct_equipment.name + 'a')
   	expect(results).not_to include(@correct_equipment)
  end
	
	it 'should return equipments for a room name' do
   	results = Equipment.rooms("AAAA")
   	expect(results).not_to include(@correct_equipment)
  end

	it 'should return equipments for a category' do
   	results = Equipment.category(@correct_equipment.category)
   	expect(results).to include(@correct_equipment)
   	results = Equipment.category(@correct_equipment.category+"a")
   	expect(results).not_to include(@correct_equipment)
  end

	after(:all) do
		@correct_equipment.destroy
	end
end