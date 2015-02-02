require 'rails_helper'
require 'cancan/matchers'

RSpec.describe UsersController, type: :controller do
  include Devise::TestHelpers

  let(:valid_session) { }
  let(:user) { create :user }
  let(:another_user) { create :user }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET show" do
    it "assigns user to @user" do
      get :show, {id: user.id}, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it "shows another users profile" do
      get :show, {id: another_user.id}, valid_session
      expect(response).to render_template(:show)
      expect(assigns(:user)).to eq(another_user)
    end
  end

  describe "GET edit" do
    it "assigns user to @user" do
      get :edit, {id: user.id}, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it "doesn't let a user edit another users profile" do
      get :edit, {id: another_user.id}, valid_session
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {fullname:'John Doe',
        email: user.username + '@student.hpi.de',
        email_notification: 0,
        office_phone: '1234',
        office_location: 'Berlin',
        mobile_phone: '0123',
        language: 'English'
        }
      }

      it "updates the user" do
        expect {
          put :update, {:id => user.to_param, :user => new_attributes}, valid_session
          user.reload
        }.to change(user, :updated_at)
      end

      it "updates the user" do
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        user.reload
        expect(user.fullname).to eq('John Doe')
        expect(user.email).to eq(user.username + '@student.hpi.de')
        expect(user.email_notification).to eq(false)
        expect(user.office_location).to eq('Berlin')
        expect(user.mobile_phone).to eq('0123')
        expect(user.office_phone).to eq('1234')
        expect(user.language).to eq('English')
      end

      it "assigns the requested user as @user" do
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to show path after success" do
        put :update, {:id => user.to_param, :user => new_attributes}, valid_session
        expect(response).to redirect_to(user_path(user))
      end

      it "doesn't let a user update another users profile" do
        put :update, {:id => another_user.to_param, :user => new_attributes}, valid_session
        expect(response).to redirect_to(root_path)
      end
    end

    describe "with invalid parameters" do
      let(:new_attributes_with_invalid_domain) {
        {fullname:'John Doe',
        email: user.username + '@example.com',
        email_notification: 0,
        office_phone: '1234',
        office_location: 'Berlin',
        mobile_phone: '0123',
        language: 'English'
        }
      }

      let(:new_attributes_with_invalid_username) {
        {fullname:'John Doe',
        email: user.username + 'foo@student.hpi.de',
        email_notification: 0,
        office_phone: '1234',
        office_location: 'Berlin',
        mobile_phone: '0123',
        language: 'English'
        }
      }

      it "redirects to edit path on failure" do
        put :update, {:id => user.to_param, :user => new_attributes_with_invalid_username}, valid_session
        expect(response).to redirect_to(edit_user_path(user))
      end

      it "redirects to edit path on failure" do
        put :update, {:id => user.to_param, :user => new_attributes_with_invalid_domain}, valid_session
        expect(response).to redirect_to(edit_user_path(user))
      end

    end
  end
end
