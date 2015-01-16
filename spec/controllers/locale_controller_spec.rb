require 'rails_helper'

RSpec.describe LocaleController, :type => :controller do

  describe "GET change_locale" do
    it "returns http success" do
      get :change_locale
      expect(response).to have_http_status(:success)
    end
  end

end
