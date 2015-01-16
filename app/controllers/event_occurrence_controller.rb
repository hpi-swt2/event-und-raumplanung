class EventOccurrenceController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = EventOccurrence.new( { event_id: params[:eventid].to_i, starts_occurring_at: DateTime.parse(params[:starting]), ends_occurring_at: DateTime.parse(params[:ending]) } )
    @favorite = Favorite.where('user_id = ? AND favorites.is_favorite = ? AND event_id = ?', current_user.id, true, @event.event.id);
    @user = User.find(@event.event.user_id).username
    logger.info @event.event.rooms.inspect
    @tasks = @event.event.tasks.rank(:task_order)
    # @return_url = ... (currently root_path by default)
  end
end
