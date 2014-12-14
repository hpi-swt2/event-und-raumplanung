require 'rails_helper'

RSpec.describe RoomsController, :type => :controller do
  include Devise::TestHelpers
  
  let(:user) { FactoryGirl.create(:user) }
      
  before(:each) do
    sign_in user
  end
    
  it "must run must accept an HTTP Request" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
  end
    
  describe 'GET new' do    
      it 'must show available equipment' do
        FactoryGirl.create(:equipment, :name => 'c1', :category => 'Chair', :room_id => nil)
        FactoryGirl.create(:equipment, :name => 'c2', :category => 'Chair', :room_id => nil)
        get :new
        available_equipment = @controller.instance_variable_get('@available_equipment')
        expect(available_equipment).to eq({'Chair' => 2})
      end
  end
  
  describe 'GET show' do    
      it 'must show assigned equipment' do
        room = FactoryGirl.create(:room)
        FactoryGirl.create(:equipment, :name => 'c1', :category => 'Chair', :room_id => room.id)
        FactoryGirl.create(:equipment, :name => 'c2', :category => 'Chair', :room_id => room.id)
        get :show, id: room
        assigned_equipment = @controller.instance_variable_get('@assigned_equipment')
        expect(assigned_equipment).to eq({'Chair' => 2})
      end
  end
    
  describe 'POST rooms' do # create 
        
    before(:each) do
      FactoryGirl.create :equipment, category: 'chair', room_id: nil
      FactoryGirl.create :equipment, category: 'chair', room_id: nil
    end

    it 'must create room' do
      room_params = FactoryGirl.attributes_for(:room)
      expect { post :create, :room => room_params }.to change(Room, :count).by(1) 
    end
    
    it 'must save assigned equipment' do
      # two available chairs
      room_params = FactoryGirl.attributes_for(:room)
      post :create, {:room => room_params, 'chair_equipment_count' => '1'}
      available_chairs = Equipment.where('room_id IS ? and category=?', nil, 'chair').count
      expect(available_chairs).to eq(1)
      #expect { post :create, :room => room_params }.to change(available_chairs).from(1).to(0)
    end
  end
    
  describe 'GET edit' do
  
      before(:each) do
          @room = create(:room)
      end
  
      it 'must count only available equipment' do
        FactoryGirl.create(:equipment, :name => 'c1', :category => 'Chair', :room_id => nil)
        FactoryGirl.create(:equipment, :name => 'c2', :category => 'Chair', :room_id => @room.id + 1)
        get :edit, id: @room
        available_equipment = @controller.instance_variable_get('@available_equipment')
        expect(available_equipment).to eq({'Chair' => 1})
      end
  end
    
  describe 'PATCH update' do
      before(:each) do
        @room = create(:room)
        @room_params = FactoryGirl.attributes_for(:room)
        FactoryGirl.create(:equipment, :name => 'c1', :category => 'chair', :room_id => nil)
        FactoryGirl.create(:equipment, :name => 'c2', :category => 'chair', :room_id => nil)        
      end
  
      it 'must update room with added equipment' do
        expect { patch :update, id: @room.id, :room => @room_params, 'chair_equipment_count' => '1' }.
          to change(@room.equipment, :count).from(0).to(1)
      end
      
      it 'must update room with removed equipment' do
        FactoryGirl.create(:equipment, :name => 'c3', :category => 'chair', :room_id => @room.id)        
        expect { patch :update, id: @room.id, :room => @room_params, 'chair_equipment_count' => '0' }.
          to change(@room.equipment, :count).from(1).to(0)
      end
      
      it 'must update available equipment' do
        # two available chairs
        patch :update, id: @room.id, :room => @room_params, 'chair_equipment_count' => '1'
        available_chairs = Equipment.where('room_id IS ? and category=?', nil, 'chair').count
        expect(available_chairs).to eq(1)
      end
  end
    
    describe 'DELETE destroy' do
      before(:each) do
        @room = create(:room)
      end
      
      it 'destroys room' do
        expect { delete :destroy, id: @room.id }.to change(Room, :count).from(1).to(0)
      end
      
      it 'frees assigned equipment' do
        FactoryGirl.create(:equipment, :name => 'c1', :category => 'chair', :room_id => @room.id)
        FactoryGirl.create(:equipment, :name => 'c2', :category => 'chair', :room_id => @room.id)
        delete :destroy, id: @room.id
        available_chairs = Equipment.where('room_id IS ? and category=?', nil, 'chair').count
        #expect { delete :destroy, id: @room.id }.to change(Room.equipment, :count).from(2).to(0)
        expect(available_chairs).to eq(2)
      end
    end
end
