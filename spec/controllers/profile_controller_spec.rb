require 'rails_helper'

RSpec.describe ProfileController, :type => :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:userWithoutEmail]
    sign_in userWithoutEmail
  end

  context "when a user logs in for the first time" do
    let(:userWithoutEmail) { create :userWithoutEmail }

    describe "POST update_profile" do
      it "safes the user and redirects to root path as employee" do
        post :update_profile, :email => "userwithoutemail@hpi.de"
        expect(response).to redirect_to(root_path)
        expect(User.all.last.email).to eq("userwithoutemail@hpi.de")
      end

      it "safes the user and redirects to root path as student" do
        post :update_profile, :email => "userwithoutemail@student.hpi.de"
        expect(response).to redirect_to(root_path)
        expect(User.all.last.email).to eq("userwithoutemail@student.hpi.de")
      end

      it "redirects to profile page if an invalid domain is given" do
        post :update_profile, :email => "userwithoutemail@hp.de"
        expect(response).to redirect_to("/profile")
        expect(flash[:error]).to eq(I18n.t('devise.sessions.wrong_domain'))
        expect(User.all.last.email).to eq(nil)
      end

      it "redirects to profile page if the email does not match the username" do
        post :update_profile, :email => "wrong@hpi.de"
        expect(response).to redirect_to("/profile")
        expect(flash[:error]).to eq(I18n.t('devise.sessions.wrong_email'))
        expect(User.all.last.email).to eq(nil)
      end
    end
  end
end
