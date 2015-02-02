require 'rails_helper'

RSpec.describe LocaleController, :type => :controller do

  describe "GET change_locale" do
	before(:each) { sign_in user }
	let(:user) { create :user, language: "de" }

    it "changes current user's locale to en" do
    	get :change_locale, locale: "en"
    	user.reload
	    expect(user.language).to eq 'en'
    end

    it "changes current user's locale to de if invalid locale entered" do
    	get :change_locale, locale: "ru"
    	user.reload
	    expect(user.language).to eq 'de'
    end

    it "redirects to request referer" do
	  	get :change_locale, locale: "en"
      	expect(response).to redirect_to(root_path)
    end

  end

end
