class UsersController < ApplicationController
	before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show

  end

  def edit
    authorize! :edit, @user
    flash[:notice] = t('user.hints')
    @user.firstlogin = false
    @user.save
  end

  def update
  	authorize! :edit, @user
    @user.student = is_student(user_params[:email])
    @user.save
    if not is_valid_domain(user_params[:email])
      flash[:error] = t('devise.sessions.wrong_domain')
      redirect_to edit_user_path(@user)
    elsif not is_correct_account(user_params[:email], @user.username)
      flash[:error] = t('devise.sessions.wrong_email')
      redirect_to edit_user_path(@user)
    else
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
  end

  def user_params
    params.require(:user).permit(:student, :email, :fullname, :email_notification, :office_location, :office_phone, :mobile_phone, :language)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def is_valid_domain(email)
    domains = Rails.application.config.login["domains"]
    return (email && domains.include?(email.split('@').last))
  end

  def is_correct_account(email, username)
    return (email && username == email.split('@').first)
  end

  def is_student(email)
    email_domain = email.split('@').last

    if email_domain && email_domain.split('.').first == 'student'
      return true
    else
      return false
    end
  end

end
