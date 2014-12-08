class EventsApprovalController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index] #this line needs to be removed in the future as only admins should be able to view this page

  def index
    read_and_exec_params
    check_admin_status
		@bookings = Booking.where('start BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).order(:start, :event_id)
		@events = Event.where.not({status: ['approved', 'declined']})
  end

  private
    def read_and_exec_params
      if params[:date]
        if params[:date].is_a?(Hash)
          @date = (params[:date][:year]+ '-' + params[:date][:month] + '-' + params[:date][:day]).to_date
        else
          @date = params[:date].to_date
        end
      else    
        @date = Date.today
      end
    end

    def check_admin_status
      config = YAML.load_file(Rails.root.join('config', 'config.yml'))
      admin_identity = config['admin']['identity_url']
      @user_is_admin = (current_user.identity_url == admin_identity)
    end

end
