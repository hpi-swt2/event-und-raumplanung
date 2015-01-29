require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_admin
    user = FactoryGirl.create(:adminUser)
    login(user)
    user
  end

  def create_logged_in_user
    user = FactoryGirl.create :user
    login(user)
    user
  end
  def login(user)
    login_as user, scope: :user
  end

  
end
