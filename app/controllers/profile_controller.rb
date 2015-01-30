class ProfileController < ApplicationController
  before_action :authenticate_user!

  helper_method :update_profile

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
    @me.email = params["email"]
    @me.email_notification = params["emailnotifications"]
    @me.fullname = params["fullname"]
    @me.office_location = params["officelocation"]
    @me.office_phone = params["officephone"]
    @me.mobile_phone = params["mobilephone"]
    @me.language = params["language"]

    @me.student = is_student(params["email"])

    if not is_valid_domain(params["email"])
      flash[:error] = t('devise.sessions.wrong_domain')
      redirect_to "/profile"
    elsif not is_correct_account(params["email"], @me.username)
      flash[:error] = t('devise.sessions.wrong_email')
      redirect_to "/profile"
    else
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
