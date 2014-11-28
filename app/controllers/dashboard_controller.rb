class DashboardController < ApplicationController

	def index
    @events = next_five_events
		
  end

  private

    def next_five_events
      return Event.where("starts_at <= '#{(Time.current.to_s(:db))}'").order('starts_at ASC').limit(5)
    end
end