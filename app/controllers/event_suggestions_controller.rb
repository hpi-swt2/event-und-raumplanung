class EventSuggestionsController < GenericEventsController
  before_action :authenticate_user!
  before_action :set_event_suggestion, only: [:show, :edit, :update, :destroy]
  
  before_action :get_instance_variable, only: [:create, :update, :destroy]
  before_action :get_model, only: [:new, :create, :update, :destroy]

  def index
    @event_suggestions = EventSuggestion.all
      respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    # respond_with(@event_suggestion)
  end

  def new
    super
  end

  def edit
  end

  def create
    super
    logger.info @event_suggestion.inspect
  end

  def update
    @update_result = @event_suggestion.update(event_suggestion_params)
    super
  end

  def destroy
    super
  end

  private
    def set_event_suggestion
      @event_suggestion = EventSuggestion.find(params[:id])
    end

    def event_suggestion_params
      params.require(:event_suggestion).permit(:event_suggestion_id, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :event_id, :room_ids => [])
    end
end
