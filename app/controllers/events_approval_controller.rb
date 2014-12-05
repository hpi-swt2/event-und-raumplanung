class EventsApprovalController < ApplicationController

	before_action :read_and_exec_params
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


  def index
		@bookings = Booking.where('start BETWEEN ? AND ?', @date.beginning_of_day, @date.end_of_day).order(:start, :event_id)
		@events = Event.where.not({status: ['approved', 'declined']})
  end

end
