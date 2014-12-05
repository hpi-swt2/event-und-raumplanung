require_relative '../../app/models/equipment'
require 'spec_helper'

describe Equipment do  
  
  it 'returns equipment categories and count of remaining equipment' do
    #Equipment.all.delete_all
    #FactoryGirl.create(:chair, :category => "Chair")
    #FactoryGirl.create(:chair, :category => "Chair")
    #Equipment.all
    #Equipment.get_available_equipment
    Equipment.stubs(:get_available_equipment_for).returns({'beamer' => 2})

    
    expect(Equipment.get_available_equipment_for).to eq({"Chair" =>2})
  end
end
