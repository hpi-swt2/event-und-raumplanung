class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :accept, :decline]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    @events = Event.all
    @event_id = event_id
    @tasks.where! event_id: event_id if event_id
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    unless params[:event_id].blank?
      @task.event_id = params[:event_id] 
      @event_field_readonly = :true
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    create_params = task_params_with_attachments
    if create_params[:user_id].blank?
      create_params[:status] = "not_assigned"
    else
      create_params[:status] = "pending"
    end
    @task = Task.new(create_params)

    respond_to do |format|
      if @task.save
        if @task.user
          @task.send_notification
        end

        format.html { redirect_to @task, notice: t('notices.successful_create', :model => Task.model_name.human) }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    update_params = task_params
    if update_params[:user_id].blank?
      update_params[:status] = "not_assigned"
    elsif update_params[:user_id].to_i != @task.user_id.to_i
      update_params[:status] = "pending"
    end
    respond_to do |format|
      if @task.update_and_send_notification(update_params)
        format.html { redirect_to @task, notice: t('notices.successful_update', :model => Task.model_name.human) }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('notices.successful_destroy', :model => Task.model_name.human) }
      format.json { head :no_content }
    end
  end

  def accept
    if @task.user_id
      @task.status = "accepted"
      @task.save
    end
    redirect_to @task
  end

  def decline
    if @task.user_id
      @task.status = "declined"
      @task.save
    end
    redirect_to @task
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :event_id, :user_id, :done)
    end
    def task_params_with_attachments
      params.require(:task).permit(:name, :description, :event_id, :user_id, :done, :attachments_attributes => [ :title, :url ])
    end
    def event_id
      if params[:event]
        return params[:event][:event_id] unless params[:event][:event_id].empty?
      end
      nil
    end
end
