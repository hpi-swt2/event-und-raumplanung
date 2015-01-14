require 'rails_helper'
require "cancan/matchers"

RSpec.describe EquipmentController, :type => :controller do
  include Devise::TestHelpers

  let(:valid_session) {}
  let(:user) { create :user }
  let(:adminUser) { create :adminUser }

  let(:valid_attributes) {
    {name:'Beamer HD',
    category: "Beamer"
    }
  }
  let(:invalid_attributes) {
    {
    category: "Beamer"
    }
  }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  before(:each, :isAdmin => true) do
    @request.env["devise.mapping"] = Devise.mappings[:adminUser]
    sign_in adminUser
  end

  describe "GET index" do
    it "assigns all equipments as @equipment" do
      equipment = Equipment.create! valid_attributes
      sign_in user
      get :index, {}, valid_session
      expect(assigns(:equipment)).to eq([equipment])
    end
  end

  describe "GET new" do
    it "assigns a new equipment as @equipment" do
      get :new, {}, valid_session
      expect(assigns(:equipment)).to be_a_new(Equipment)
    end
  end

  describe "GET edit" do
    it "assigns the requested equipment as @equipment" do
      equipment = Equipment.create! valid_attributes
      get :edit, {:id => equipment.to_param}, valid_session
      expect(assigns(:equipment)).to eq(equipment)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "creates a new Equipment", :isAdmin => true do
        expect {
          post :create, {:equipment => valid_attributes}, valid_session
        }.to change(Equipment, :count).by(1)
      end

      it "assigns a newly created equipment as @equipment" do
        post :create, {:equipment => valid_attributes}, valid_session
        expect(assigns(:equipment)).to be_a(Equipment)
      end

      it "redirects to the index site" do
        post :create, {:equipment => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @equipment" do
        post :create, {:equipment => invalid_attributes}, valid_session
        expect(assigns(:equipment)).to be_a_new(Equipment)
      end

      it "does not create a new Equipment", :isAdmin => true do
        expect {
          post :create, {:equipment => invalid_attributes}, valid_session
        }.to change(Equipment, :count).by(0)
      end
    end
    
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name:'New Beamer',
        category: 'New Category'
        }
      }

      it "updates the requested equipment", :isAdmin => true do
        equipment = Equipment.create! valid_attributes
        put :update, {:id => equipment.to_param, :equipment => new_attributes}, valid_session
        equipment.reload
        expect(equipment.name).to eq 'New Beamer'
        expect(equipment.category).to eq 'New Category'
      end

      it "assigns the requested event as @equipment" do
        equipment = Equipment.create! valid_attributes
        put :update, {:id => equipment.to_param, :equipment => valid_attributes}, valid_session
        expect(assigns(:equipment)).to eq(equipment)
      end

      it "redirects to the event" do
        equipment = Equipment.create! valid_attributes
        put :update, {:id => equipment.to_param, :equipment => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "assigns the event as @equipment" do
        equipment = Equipment.create! valid_attributes
        put :update, {:id => equipment.to_param, :equipment => invalid_attributes}, valid_session
        expect(assigns(:equipment)).to eq(equipment)
      end
    end
  end

  describe "DELETE destroy", :isAdmin => true do
    it "destroys the requested equipment" do
      equipment = Equipment.create! valid_attributes
      expect {
        delete :destroy, {:id => equipment.to_param}, valid_session
      }.to change(Equipment, :count).by(-1)
    end

    it "redirects to the equipment list" do
      equipment = Equipment.create! valid_attributes
      delete :destroy, {:id => equipment.to_param}, valid_session
      expect(response).to redirect_to(equipment_index_url)
    end
  end

  describe "get Categories" do
    it "gets all distinct Categories" do
      equipment = Equipment.create! valid_attributes
      categoryArray = Array.new
      categoryArray << ["Beamer","Beamer"]
    
      controller.getCategories().should == categoryArray
    end
  end
end