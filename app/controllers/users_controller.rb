class UsersController < ApplicationController
	before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show

  end

  def edit
    authorize! :edit, @user
    @firstlogin = @user.firstlogin
    @user.firstlogin = false
    @user.save
  end

  def update
  	authorize! :edit, @user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: t('notices.successful_update', :model => User.model_name.human) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_params
    params.require(:user).permit(:fullname, :email_notification, :office_location, :office_phone, :mobile_phone, :language)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
