class EventsApprovalController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource
  skip_load_and_authorize_resource :only =>[:index] #this line needs to be removed in the future as only admins should be able to view this page

  def index
    read_and_exec_params
    check_admin_status
    @events = Event.open.order(:starts_at)
		@bookings = Booking.start_at_day(@date).approved.order(:start, :event_id)
  end

  private
    def read_and_exec_params
      if params[:date]
        begin
          if params[:date].is_a?(Hash)
            @date = (params[:date][:year]+ '-' + params[:date][:month] + '-' + params[:date][:day]).to_date
          else
            @date = params[:date].to_date
          end
        rescue
        end
      end    
      @date = Date.today unless !@date.nil? && @date.acts_like_date?
    end

    def check_admin_status
      config = YAML.load_file(Rails.root.join('config', 'config.yml'))
      admin_identity = config['admin']['identity_url']
      @user_is_admin = (current_user.identity_url == admin_identity)
    end

end
