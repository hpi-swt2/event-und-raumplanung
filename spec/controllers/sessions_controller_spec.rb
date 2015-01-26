require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET new" do
    it "bla" do
      get :new
      expect(@admin).to be_nil
    end
  end

  context "user is admin" do
    describe "POST create" do
      let(:admin) { build(:adminUser) }

      it "requires a vaild password after passing e-mail-address" do
        # login as admin for the first time
        post :create, :user => { :email => admin.email }
        expect(response).to redirect_to new_user_session_path("admin" => "")

        post :create, :user => { :encrypted_password => admin.encrypted_password }
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted

        # session logout
        delete :destroy

        # login again, but this time admin is already persisted
        post :create, :user => { :email => admin.email}
        expect(response).to redirect_to new_user_session_path("admin" => "")
        
        post :create, :user => { :encrypted_password => admin.encrypted_password}
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "rejects an invalid admin password" do
        # login as admin for the first time
        post :create, :user => { :email => admin.email }
        expect(response).to redirect_to new_user_session_path("admin" => "")

        post :create, :user => { :encrypted_password => "wrongPassword:P" }
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to be_nil
        expect(flash[:error]).to eq(I18n.t('devise.failure.invalid'))
      end
    end
  end

  context "user is student" do
    describe "POST create" do
      let(:user) { build(:user) }
      let(:hpi_user) { build(:hpiUser) }

      it "rejects an invalid email domain" do
        post :create, :user => { :email => user.email }, :authenticity_token => "abc"
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to be_nil
        expect(flash[:error]).to eq(I18n.t('devise.sessions.wrong_domain'))
      end

      it "logs in with a valid email address" do
        # mock openID authentication
        allow(request.env['warden']).to receive(:authenticate!).and_return(hpi_user)
        allow(controller).to receive(:current_user).and_return(hpi_user)
        controller.store_location_for(:user, root_path)
        
        post :create, :user => { :email => hpi_user.email }, :authenticity_token => "abc"
        expect(response).to redirect_to(edit_user_path(hpi_user))
        expect(controller.signed_in?).to be true
      end
    end
  end
end
