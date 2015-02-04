require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers

  #
  #
  def create_logged_in_admin
    user = FactoryGirl.create(:adminUser)
    log_in(user)
    user
  end

  #
  #
  def create_logged_in_user
    user = FactoryGirl.create :user
    log_in(user)
    user
  end
  
  #
  #
  def log_in(user)
    login_as user, scope: :user
  end

end
