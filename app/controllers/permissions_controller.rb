class PermissionsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    @categories = Permission.categories.keys
    @permission = Permission.new
    @user = current_user
  end



end
