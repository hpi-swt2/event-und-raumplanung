require 'rails_helper'

RSpec.describe PermissionsController, :type => :controller do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GroupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user) { create :user }
  let(:group) { create :group }
  let(:adminUser) { create :adminUser }
  let(:room) { create :room }
  let(:another_room) { create :room }

  let(:permission_parameters) {
    {
      type: 'permission',
      permission: 'edit_rooms',
      format: :json
    }
  }

  let(:permission_for_room_parameters) {
    {
      type: 'permission',
      permission: 'approve_events',
      rooms: {
        approve_events: [room.id.to_s]
      },
      format: :json
    }
  }

  let(:permission_for_all_rooms_parameters) {
    {
      type: 'permission',
      permission: 'approve_events',
      rooms: {
        approve_events: ['all']
      },
      format: :json
    }
  }

  let(:user_parameters) {
    {
      type: 'entity',
      entity: 'User:' + user.id.to_s,
      edit_rooms: '1',
      format: :json
    }
  }

  let(:user_parameters_for_room) {
    {
      type: 'entity',
      entity: 'User:' + user.id.to_s,
      approve_events: '1',
      rooms: {
        approve_events: [room.id.to_s]
      },
      format: :json
    }
  }

  let(:user_parameters_for_all_rooms) {
    {
      type: 'entity',
      entity: 'User:' + user.id.to_s,
      approve_events: '1',
      rooms: {
        approve_events: ['all']
      },
      format: :json
    }
  }

  let(:group_parameters) {
    {
      type: 'entity',
      entity: 'Group:' + group.id.to_s,
      edit_rooms: '1',
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

      it "updates a users permissions", :isAdmin => true do
        expect(user.has_permission('edit_rooms')).to be(false)
        post :submit, user_parameters, valid_session
        expect(user.has_permission('edit_rooms')).to be(true)
      end

      it "updates a users permissions for specific rooms", :isAdmin => true do
        expect(user.has_permission('approve_events', room)).to be(false)
        expect(user.has_permission('approve_events', another_room)).to be(false)
        post :submit, user_parameters_for_room, valid_session
        expect(user.has_permission('approve_events', room)).to be(true)
        expect(user.has_permission('approve_events', another_room)).to be(false)
      end

      it "updates a users permissions for all rooms", :isAdmin => true do
        expect(user.has_permission('approve_events', room)).to be(false)
        expect(user.has_permission('approve_events', another_room)).to be(false)
        post :submit, user_parameters_for_all_rooms, valid_session
        expect(user.has_permission('approve_events', room)).to be(true)
        expect(user.has_permission('approve_events', another_room)).to be(true)
      end

      it "updates a groups permission", :isAdmin => true do
        expect(group.has_permission('edit_rooms')).to be(false)
        post :submit, group_parameters, valid_session
        expect(group.has_permission('edit_rooms')).to be(true)
      end

      it "updates users or groups for permission", :isAdmin => true do
        expect(user.has_permission('edit_rooms')).to be(false)
        permission_parameters['User:' + user.id.to_s] = '1'
        post :submit, permission_parameters, valid_session
        expect(user.has_permission('edit_rooms')).to be(true)
      end

      it "updates users or groups for permission for specific rooms", :isAdmin => true do
        expect(user.has_permission('approve_events', room)).to be(false)
        expect(user.has_permission('approve_events', another_room)).to be(false)
        permission_for_room_parameters['User:' + user.id.to_s] = '1'
        post :submit, permission_for_room_parameters, valid_session
        expect(user.has_permission('approve_events', room)).to be(true)
        expect(user.has_permission('approve_events', another_room)).to be(false)
      end

      it "updates users or groups for permission for all rooms", :isAdmin => true do
        expect(user.has_permission('approve_events', room)).to be(false)
        expect(user.has_permission('approve_events', another_room)).to be(false)
        permission_for_all_rooms_parameters['User:' + user.id.to_s] = '1'
        post :submit, permission_for_all_rooms_parameters, valid_session
        expect(user.has_permission('approve_events', room)).to be(true)
        expect(user.has_permission('approve_events', another_room)).to be(true)
      end
    end

    describe "POST checkboxes_by_entity" do
      it "redirects to the root path as normal user", :isAdmin => false do
        post :checkboxes_by_entity, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "renders checkboxes_by_entity as admin user", :isAdmin => true do
        post :checkboxes_by_entity, {entity: 'User:' + user.id.to_s}, valid_session
        expect(response).to render_template('permissions/_checkboxes_by_entity')
      end
    end

    describe "POST checkboxes_by_permission" do
      it "redirects to the root path as normal user", :isAdmin => false do
        post :checkboxes_by_permission, {}, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "renders checkboxes_by_permission as admin user", :isAdmin => true do
        post :checkboxes_by_permission, {permission: 'edit_rooms'}, valid_session
        expect(response).to render_template('permissions/_checkboxes_by_permission')
      end
    end

  end

end
