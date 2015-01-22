class ProfileController < ApplicationController
	before_action :authenticate_user!

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def update_profile
  	@me = User.find_by(id: current_user.id)
    @me.email_notification = params["emailnotifications"]
    @me.fullname = params["fullname"]
    @me.office_location = params["officelocation"]
    @me.office_phone = params["officephone"]
    @me.mobile_phone = params["mobilephone"]
    @me.language = params["language"]

    respond_to do |format|
      if @me.save
        format.html { redirect_to "/", notice: t('notices.successful_update', :model => User.model_name.human) }
        format.json { render :show }
      else
        format.html { render :new }
        format.json { render json: @me.errors, status: :unprocessable_entity }
      end
    end
  end
  helper_method :update_profile

end
