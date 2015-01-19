require 'rails_helper'
require "cancan/matchers"

describe "Equipment", :type => :request do

  before(:all) do
    @normal_user = FactoryGirl.create(:user) 
    @admin = FactoryGirl.create(:adminUser)
    @normal_user_ability = Ability.new(@normal_user)
    @admin_ability = Ability.new(@admin)
  end

  context "when user is not logged-in" do
    describe "GET /equipment" do
      it "should redirect to login" do
        get equipment_index_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  it "lets only admin users and those with permissions create and delete equipment" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("manage_equipment")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:create, :destroy]
    equipment = FactoryGirl.create(:equipment)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, equipment)
      expect(permitted_user_ability).to be_able_to(method, equipment)
      expect(@admin_ability).to be_able_to(method, equipment)
    }
  end

  it "lets only admin users and those with permissions update equipment" do 
    permitted_user = FactoryGirl.create(:user)
    permitted_user.permit("edit_equipment")
    permitted_user_ability = Ability.new(permitted_user)
    methods = [:update]
    equipment = FactoryGirl.create(:equipment)
    methods.each { |method| 
      expect(@normal_user_ability).not_to be_able_to(method, equipment)
      expect(permitted_user_ability).to be_able_to(method, equipment)
      expect(@admin_ability).to be_able_to(method, equipment)
    }
  end

end 
