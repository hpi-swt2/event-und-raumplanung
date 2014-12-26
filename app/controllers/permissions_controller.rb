class PermissionsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    @categories = Permission.categories.keys
  end

end
