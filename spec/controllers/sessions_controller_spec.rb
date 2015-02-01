require 'rails_helper'
require 'pp'

RSpec.describe SessionsController, :type => :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET admin" do
    it "renders the admin login page" do
      get :show_admin_login
      expect(response.status).to eq(200)
    end
  end

  context "is admin" do
    describe "POST create" do
      let(:admin) { build(:adminUser) }

      it "redirects the admin user to the root" do
        # login as admin for the first time
        post :authenticate_admin, :email => admin.email, :encrypted_password => admin.encrypted_password
        expect(response).to redirect_to root_path

        sign_out admin
        delete :destroy

        # login again, but this time admin is already persisted
        post :authenticate_admin, :email => admin.email, :encrypted_password => admin.encrypted_password
        expect(response).to redirect_to root_path
      end

      it "rejects an invalid admin password" do
        post :authenticate_admin, :email => admin.email, :encrypted_password => "wrongPassword:P"
        expect(response).to redirect_to admin_path

        expect(flash[:error]).to eq(I18n.t('devise.failure.invalid'))
      end
    end
  end

  context "is normal user" do
    describe "POST create" do
      let(:user) { create(:user) }

      context "with a success response" do
        before(:each) do
          # mock openID authentication
          User.delete_all
          endpoint = double('EndPoint')
          endpoint.stubs(:claimed_id).returns('http://openid.example.org/hpi_user')
          success  = OpenID::Consumer::SuccessResponse.new(endpoint, OpenID::Message.new, "")
          OpenID::Consumer.any_instance.stubs(:complete_id_res).returns(success)
          @request.env[Rack::OpenID::RESPONSE] = success
        end

        it "logs in without a valid email address" do
          post :create
          expect(response).to redirect_to(edit_user_path(controller.current_user.id))

          expect(controller.current_user).to be_a(User)

          post :new
          expect(response).to redirect_to root_path
        end

        it "logs in with a valid email address" do
          user = User.create(:username => "hpi_user", :email => "hpi_user@student.hpi.de")
          controller.store_location_for(:user, "/")

          post :create
          expect(response).to redirect_to root_path

          expect(controller.current_user).to be_a(User)

          post :new
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
