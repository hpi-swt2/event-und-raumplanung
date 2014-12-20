class EventSuggestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_suggestion, only: [:show, :edit, :update, :destroy]

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
    @event_suggestion = EventSuggestion.new
    time = Time.new.getlocal
    time -= time.sec
    time += time.min % 15
    @event_suggestion.starts_at = time
    @event_suggestion.ends_at = (time+(60*60))
  end

  def edit
  end

  def create
    logger.info event_suggestion_params.inspect
    @event_suggestion = EventSuggestion.new(event_suggestion_params)
    respond_to do |format|
      if @event_suggestion.save
        format.html { redirect_to @event_suggestion, notice: t('notices.successful_create', :model => EventSuggestion.model_name.human) } # redirect to overview
        format.json { render :show, status: :created, location: @event_suggestion }
      else
        format.html { render :new }
        format.json { render json: @event_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event_suggestion.update(event_suggestion_params)
        format.html { redirect_to @event_suggestion, notice: t('notices.successful_update', :model => EventSuggestion.model_name.human) }
        format.json { render :show, status: :ok, location: @event_suggestion }
      else
        format.html { render :edit }
        format.json { render json: @event_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event_suggestion.destroy
    respond_to do |format|
      format.html { redirect_to event_suggestions_path, notice: t('notices.successful_destroy', :model => EventSuggestion.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    def set_event_suggestion
      @event_suggestion = EventSuggestion.find(params[:id])
    end

    def event_suggestion_params
      params.require(:event_suggestion).permit(:event_suggestion_id, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time, :room_ids => [])
    end
end
