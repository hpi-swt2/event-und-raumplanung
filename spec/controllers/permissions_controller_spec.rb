require 'rails_helper'

RSpec.describe PermissionsController, :type => :controller do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GroupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create :user }
  let(:group) { create :group }
  let(:adminUser) { create :adminUser }

  let(:permission_parameters) {
    {
      type: 'permission',
      permission: 'edit_rooms',
      format: :json
    }
  }

  let(:user_parameters) {
    {
      type: 'entity',
      entity: 'User:' + user.id.to_s,
      format: :json
    }
  }

  let(:group_parameters) {
    {
      type: 'entity',
      entity: 'Group:' + group.id.to_s,
      format: :json
    }
  }

  context "when user is logged-in" do

    before(:each, :isAdmin => false) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    before(:each, :isAdmin => true) do
      @request.env["devise.mapping"] = Devise.mappings[:adminUser]
      sign_in adminUser
    end

    describe "GET index" do
      it "redirects to the root path as normal user", :isAdmin => false do
        get :index, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "assigns variables as admin", :isAdmin => true do
        get :index, {}, valid_session
        expect(assigns(:groups)).to eq(Group.all)
        expect(assigns(:users)).to eq(User.all)
        expect(assigns(:categories)).to eq(Permission.categories.keys)
      end
    end

    describe "POST submit" do
      it "redirects to the root path as normal user", :isAdmin => false do
        post :submit, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "user", :isAdmin => true do
        post :submit, user_parameters, valid_session
      end

      it "group", :isAdmin => true do
        post :submit, group_parameters, valid_session
      end

      it "permissions", :isAdmin => true do
        post :submit, permission_parameters, valid_session
      end
    end

    describe "POST checkboxes_by_entity" do
      it "redirects to the root path as normal user", :isAdmin => false do
        post :checkboxes_by_entity, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path as normal user", :isAdmin => true do
        post :checkboxes_by_entity, {entity: 'User:' + user.id.to_s}, valid_session
      end
    end

    describe "POST checkboxes_by_permission" do
      it "redirects to the root path as normal user", :isAdmin => false do
        post :checkboxes_by_permission, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the root path as normal user", :isAdmin => true do
        post :checkboxes_by_permission, {permission: 'edit_rooms'}, valid_session
      end
    end

  end

end
