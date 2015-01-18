class EventOccurrenceController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_params, only: :show

  def show
    @event = EventOccurrence.new( { event_id: event_occurrence_params[:eventid].to_i, starts_occurring_at: DateTime.parse(event_occurrence_params[:starting]), ends_occurring_at: DateTime.parse(event_occurrence_params[:ending]) } )
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite = ? AND event_id = ?', current_user.id, true, @event.event.id);
    @user = User.find(@event.event.user_id).username
    logger.info @event.event.rooms.inspect
    @tasks = @event.event.tasks.rank(:task_order)
    # @return_url = ... (currently root_path by default)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_occurrence_params
      params.require(:eventid)
      params.require(:starting)
      params.require(:ending)
      return params
    end

    def validate_params
      event_id = event_occurrence_params[:eventid].to_i
      if Event.find(event_id).nil? || occurrence_invalid?(event_id, Time.parse(event_occurrence_params[:starting]), Time.parse(event_occurrence_params[:ending]))
        raise ActionController::RoutingError.new('Not found')
      end
    end

    def occurrence_invalid?(event_id, starting, ending)
      event = Event.find(event_id)
      schedule = event.schedule
      next_occurrence = schedule.next_occurrence(starting - 1.seconds)
      if next_occurrence.present? && next_occurrence == starting && (next_occurrence + event.duration) == ending
        return false
      end
      return true
    end
end
