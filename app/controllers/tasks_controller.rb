class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :set_done, :destroy, :accept, :decline, :upload_file]
  before_action :set_return_url, only: [:show, :new, :edit]

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
    authorize! :read, @task
  end

  # GET /tasks/new
  def new
    @task = Task.new
    unless params[:event_id].blank?
      @task.event_id = params[:event_id] 
      @event_field_readonly = :true
      authorize! :create, @task
    end
  end

  # GET /tasks/1/edit
  def edit
    authorize! :edit, @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    unless params[:task][:identity].blank?
        identity_params = params[:task][:identity].match(/^(?<type>\w+):(?<id>\d+)$/)
    end

    @task = Task.new(set_status task_params_with_attachments)
    unless params[:task][:identity].blank? 
      @task.identity_id         =  identity_params[:id]
      @task.identity_type       =  identity_params[:type]
    end

    @task.done = false
    authorize! :create, @task
    respond_to do |format|
      if @task.save
        if @task.identity
          @task.send_notification_to_assigned_user(current_user)
        end
        upload_files if params[:uploads]

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
    authorize! :update, @task

    upload_files if params[:uploads]
    delete_files if params[:delete_uploads]

    if params[:task][:identity].blank?
      params[:task][:identity_id] = nil
      params[:task][:identity_type] = nil
    else
      identity_params = params[:task][:identity].match(/^(?<type>\w+):(?<id>\d+)$/)
      params[:task][:identity_id] = identity_params[:id]
      params[:task][:identity_type] = identity_params[:type]
    end

    respond_to do |format|
      if @task.update_and_send_notification((set_status task_params), current_user)
        format.html { redirect_to @task, notice: t('notices.successful_update', :model => Task.model_name.human) }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_done
    authorize! :set_done, @task
    @task.update(task_set_done_params)
    render nothing: true
  end

  def update_task_order
    @task = Task.find(task_update_order_params[:task_id])
    authorize! :update, @task
    @task.task_order_position = task_update_order_params[:task_order_position]
    @task.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end


  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    authorize! :destroy, @task
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('notices.successful_destroy', :model => Task.model_name.human) }
      format.json { head :no_content }
    end
  end

  def accept
    authorize! :accept, @task
    if @task.identity
      @task.status = "accepted"
      @task.save
    end
    
    respond_to do |format| 
      format.html { redirect_to @task }
      format.json { render json: @task }
    end

  end

  def decline
    authorize! :decline, @task
    if @task.identity
      if @task.status == "accepted"
        flash[:error] = t('.you_already_accepted_this_task')
      else
        @task.status = "declined"
        @task.save
      end
    end
    redirect_to @task
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_return_url
      @return_url = tasks_path
      @return_url = root_path if request.referrer && URI(request.referer).path == root_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :event_id, :identity, :identity_id, :identity_type, :done, :deadline)
    end

    def task_params_with_attachments
      params.require(:task).permit(:name, :description, :event_id, :identity, :identity_id, :identity_type, :done, :deadline, :attachments_attributes => [ :title, :url ])
    end

    def task_update_order_params
      params.require(:task).permit(:task_id, :task_order_position)
    end

    def task_set_done_params
      params.require(:task).permit(:done)
    end

    def event_id
      if params[:event]
        return params[:event][:event_id] unless params[:event][:event_id].empty?
      end
      nil
    end

    def set_status(params)
      updated_params = params
      if !@task
        if updated_params[:identity].blank?
          updated_params[:status] = "not_assigned"
        else
          updated_params[:status] = "pending"
        end
      else
        if updated_params[:identity].blank?
          updated_params[:status] = "not_assigned"
        elsif !@task.identity.nil? and updated_params[:identity] != @task.identity_type + ":" + @task.identity_id.to_s
          updated_params[:status] = "pending"
        end
      end
      updated_params.delete(:identity)
      return updated_params
    end

    def upload_files
      params[:uploads].each { |upload| @task.uploads.create!(:file => upload) }
    end

    def delete_files
      params[:delete_uploads].each { |id, value| Upload.find(id).destroy! if value == 'true' }
    end
end
