require 'rails_helper'
require 'cancan/matchers'

RSpec.describe RoomPropertiesController, type: :controller do
  include Devise::TestHelpers

  let(:valid_session) { }
  let(:user) { create :user }
  let(:adminUser) { create :adminUser }
  let(:property) { create :room_property }

  describe "for admin user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in adminUser
    end

    describe "GET index" do
      it "assigns RoomProperty.all to @roomProperties and renders index view" do
        get :index, {}, valid_session
        expect(assigns(:roomProperties)).to eq(RoomProperty.all)
        expect(response).to render_template(:index)
      end
    end

    describe "GET show" do
      it "assigns roomProperty to @roomProperty and renders show view" do
        get :show, {id: property.to_param}, valid_session
        expect(assigns(:roomProperty)).to eq(property)
        expect(response).to render_template(:show)
      end
    end

    describe "GET edit" do
      it "assigns roomProperty to @roomProperty and renders edit view" do
        get :edit, {id: property.to_param}, valid_session
        expect(assigns(:roomProperty)).to eq(property)
        expect(response).to render_template(:edit)
      end
    end

    describe "GET new" do
      it "assigns roomProperty to @roomProperty and renders new view" do
        get :new, {}, valid_session
        expect(response).to render_template(:new)
      end
    end

    describe "PUT update" do
      let(:new_attributes) {
        {name: 'Foo'}
      }

      it "updates the property" do
        expect {
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          property.reload
        }.to change(property, :updated_at)
      end

      it "updates the property" do
        put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
        property.reload
        expect(property.name).to eq('Foo')
      end

      it "assigns the requested property as @roomProperty" do
        put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
        expect(assigns(:roomProperty)).to eq(property)
      end

      it "redirects to show path after success" do
        put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
        expect(response).to redirect_to(room_properties_url)
      end
    end

    describe "POST create" do
      let(:attributes) {
        {name: 'Foo'}
      }

      it "creates the property" do
        expect {
          post :create, {:room_property => attributes}, valid_session
        }.to change(RoomProperty, :count)
      end

      it "redirects to show path after success" do
        post :create, {:room_property => attributes}, valid_session
        expect(response).to redirect_to(room_properties_url)
      end
    end

    describe "DELETE destroy" do
      before(:each) do
        @persistedProperty = RoomProperty.new(name: 'foo')
        @persistedProperty.save
      end
      
      it "destroys the property" do
        expect {
          delete :destroy, {:id => @persistedProperty.to_param}, valid_session
        }.to change(RoomProperty, :count)
      end

      it "destroys the property" do
        delete :destroy, {:id => @persistedProperty.to_param}, valid_session
        expect(response).to redirect_to(room_properties_url)
      end

      after(:each) do
        @persistedProperty.destroy
      end
    end

  end

  describe "for normal user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "with no permissions" do
      describe "GET index" do
        it "redirects to root_path" do
          get :index, {}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "GET show" do
        it "redirects to root_path" do
          get :show, {id: property.to_param}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "GET edit" do
        it "redirects to root_path" do
          get :edit, {id: property.to_param}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "GET new" do
        it "redirects to root_path" do
          get :new, {}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "PUT update" do
        let(:new_attributes) {
          {name: 'Foo'}
        }

        it "doesn't update the property" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          property.reload
          expect(property.name).not_to eq('Foo')
        end

        it "redirects to root_path" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "POST create" do
        let(:attributes) {
          {name: 'Foo'}
        }

        it "doesn't create the property" do
          expect {
            post :create, {:room_property => attributes}, valid_session
          }.not_to change(RoomProperty, :count)
        end

        it "redirects to root_path" do
          post :create, {:room_property => attributes}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "DELETE destroy" do
        before(:each) do
          @persistedProperty = RoomProperty.new(name: 'foo')
          @persistedProperty.save
        end
        
        it "doesn't destroy the property" do
          expect {
            delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          }.not_to change(RoomProperty, :count)
        end

        it "destroys the property" do
          delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          expect(response).to redirect_to(root_path)
        end

        after(:each) do
          @persistedProperty.destroy
        end
      end
    end

    describe "with edit_properties permission" do
      before(:each) do
        user.permit("edit_properties")
      end

      describe "GET index" do
        it "assigns RoomProperty.all to @roomProperties and renders index view" do
          get :index, {}, valid_session
          expect(assigns(:roomProperties)).to eq(RoomProperty.all)
          expect(response).to render_template(:index)
        end
      end

      describe "GET show" do
        it "assigns roomProperty to @roomProperty and renders show view" do
          get :show, {id: property.to_param}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
          expect(response).to render_template(:show)
        end
      end

      describe "GET edit" do
        it "assigns roomProperty to @roomProperty and renders edit view" do
          get :edit, {id: property.to_param}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
          expect(response).to render_template(:edit)
        end
      end

      describe "GET new" do
        it "redirects to root_path" do
          get :new, {}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "PUT update" do
        let(:new_attributes) {
          {name: 'Foo'}
        }

        it "updates the property" do
          expect {
            put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
            property.reload
          }.to change(property, :updated_at)
        end

        it "updates the property" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          property.reload
          expect(property.name).to eq('Foo')
        end

        it "assigns the requested property as @roomProperty" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
        end

        it "redirects to show path after success" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          expect(response).to redirect_to(room_properties_url)
        end
      end

      describe "POST create" do
        let(:attributes) {
          {name: 'Foo'}
        }

        it "doesn't create the property" do
          expect {
            post :create, {:room_property => attributes}, valid_session
          }.not_to change(RoomProperty, :count)
        end

        it "redirects to root_path" do
          post :create, {:room_property => attributes}, valid_session
          expect(response).to redirect_to(root_path)
        end
      end

      describe "DELETE destroy" do
        before(:each) do
          @persistedProperty = RoomProperty.new(name: 'foo')
          @persistedProperty.save
        end
        
        it "doesn't destroy the property" do
          expect {
            delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          }.not_to change(RoomProperty, :count)
        end

        it "destroys the property" do
          delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          expect(response).to redirect_to(root_path)
        end

        after(:each) do
          @persistedProperty.destroy
        end
      end
    end

    describe "with manage_properties permission" do
      before(:each) do
        user.permit("manage_properties")
      end

      describe "GET index" do
        it "assigns RoomProperty.all to @roomProperties and renders index view" do
          get :index, {}, valid_session
          expect(assigns(:roomProperties)).to eq(RoomProperty.all)
          expect(response).to render_template(:index)
        end
      end

      describe "GET show" do
        it "assigns roomProperty to @roomProperty and renders show view" do
          get :show, {id: property.to_param}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
          expect(response).to render_template(:show)
        end
      end

      describe "GET edit" do
        it "assigns roomProperty to @roomProperty and renders edit view" do
          get :edit, {id: property.to_param}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
          expect(response).to render_template(:edit)
        end
      end

      describe "GET new" do
        it "assigns roomProperty to @roomProperty and renders new view" do
          get :new, {}, valid_session
          expect(response).to render_template(:new)
        end
      end

      describe "PUT update" do
        let(:new_attributes) {
          {name: 'Foo'}
        }

        it "updates the property" do
          expect {
            put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
            property.reload
          }.to change(property, :updated_at)
        end

        it "updates the property" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          property.reload
          expect(property.name).to eq('Foo')
        end

        it "assigns the requested property as @roomProperty" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          expect(assigns(:roomProperty)).to eq(property)
        end

        it "redirects to show path after success" do
          put :update, {:id => property.to_param, :room_property => new_attributes}, valid_session
          expect(response).to redirect_to(room_properties_url)
        end
      end

      describe "POST create" do
        let(:attributes) {
          {name: 'Foo'}
        }

        it "creates the property" do
          expect {
            post :create, {:room_property => attributes}, valid_session
          }.to change(RoomProperty, :count)
        end

        it "redirects to show path after success" do
          post :create, {:room_property => attributes}, valid_session
          expect(response).to redirect_to(room_properties_url)
        end
      end

      describe "DELETE destroy" do
        before(:each) do
          @persistedProperty = RoomProperty.new(name: 'foo')
          @persistedProperty.save
        end
        
        it "destroys the property" do
          expect {
            delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          }.to change(RoomProperty, :count)
        end

        it "destroys the property" do
          delete :destroy, {:id => @persistedProperty.to_param}, valid_session
          expect(response).to redirect_to(room_properties_url)
        end

        after(:each) do
          @persistedProperty.destroy
        end
      end
    end

  end
end
