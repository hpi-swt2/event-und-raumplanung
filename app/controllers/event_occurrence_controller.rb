class EventOccurrenceController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_params, only: [ :show, :destroy, :decline ]
  before_action :event_occurrence_from_params, only: [ :show, :destroy, :decline ]
  before_action :set_feed, only: [:show]

  def show
    authorize! :show, @event
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite = ? AND event_id = ?', current_user.id, true, @event.id);
    @user = User.find(@event.user_id) unless @event.user_id.nil?
    if current_user.id == @event.user_id
      @tasks = @event.tasks.rank(:task_order)
    else
      @tasks = @event.tasks.where('identity_type = \'User\' AND identity_id = ?', current_user.id).rank(:task_order)
    end
  end

  def destroy
    if can? :destroy, @event
      @event.delete_occurrence(@event_occurrence.starts_occurring_at)
    else
      raise ActionController::RoutingError.new('Not found')
    end
    flash[:notice] = t("event.alert.single_occurrence_successful_delete")
    redirect_to root_path
  end

  def decline
    if can? :decline, @event
      if @event.single_occurrence_event?
        @event.decline
      else
        single_occurrence = @event.duplicate
        single_occurrence.starts_at = @event_occurrence.starts_occurring_at
        single_occurrence.ends_at = @event_occurrence.ends_occurring_at
        single_occurrence.reset_schedule
        single_occurrence.save!

        single_occurrence.decline

        @event.delete_occurrence(@event_occurrence.starts_occurring_at)
      end
      flash[:notice] = t("event.alert.single_occurrence_successful_decline")
      redirect_to root_path
    else
      raise ActionController::RoutingError.new('Not found')
    end
  end

  private

    def event_occurrence_from_params
      @event_occurrence = EventOccurrence.new( { event_id: event_occurrence_params[:eventid].to_i, starts_occurring_at: Time.parse(event_occurrence_params[:starting]), ends_occurring_at: Time.parse(event_occurrence_params[:ending]) } )
      @event = @event_occurrence.event
    end

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
      if next_occurrence.present? && next_occurrence.to_time.to_i == starting.to_i && (next_occurrence + event.duration).to_i == ending.to_i
        return false
      end
      return true
    end

    def set_feed
      if @event.involved_users.include? current_user or can? :manage, Event
        @activities = @event.activities.all.order("created_at ASC")
        @comments = Comments.where(event_id: @event.id)
        @feed_entries = @activities + @comments
        @feed_entries = @feed_entries.sort_by(&:created_at)
      end
    end
end
