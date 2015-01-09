class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy, :accept, :decline, :upload_file]
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
    @task_user_name = ""
    @task_user_name = User.find(@task.user_id).username if @task.user_id
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(set_status task_params_with_attachments)
    @task.done = false
    respond_to do |format|
      if @task.save && upload_files
        if @task.user
          @task.send_notification_to_assigned_user(current_user)
        end
        #upload_files if params[:uploads]

        format.html { redirect_to @task, notice: t('notices.successful_create', :model => Task.model_name.human) }
        format.json { render :show, status: :created, location: @task }
      else
        @upload_errors = get_upload_errors
        delete_new_uploads
        @task.destroy
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    delete_files if params[:delete_uploads]
    
    respond_to do |format|
      if upload_files && @task.update_and_send_notification((set_status task_params), current_user)
        format.html { redirect_to @task, notice: t('notices.successful_update', :model => Task.model_name.human) }
        format.json { render :show, status: :ok, location: @task }
      else
        @upload_errors = get_upload_errors
        delete_new_uploads
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_task_order
    @task = Task.find(task_update_order_params[:task_id])
    @task.task_order_position = task_update_order_params[:task_order_position]
    @task.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
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
    
    respond_to do |format| 
      format.html { redirect_to @task }
      format.json { render json: @task }
    end

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

    def set_return_url
      @return_url = tasks_path
      @return_url = root_path if request.referrer && URI(request.referer).path == root_path
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :event_id, :user_id, :done, :deadline)
    end

    def task_params_with_attachments
      params.require(:task).permit(:name, :description, :event_id, :user_id, :done, :deadline, :attachments_attributes => [ :title, :url ])
    end

    def task_update_order_params
      params.require(:task).permit(:task_id, :task_order_position)
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
        if updated_params[:user_id].blank?
          updated_params[:status] = "not_assigned"
        else
          updated_params[:status] = "pending"
        end
      else
        if updated_params[:user_id].blank?
          updated_params[:status] = "not_assigned"
        elsif updated_params[:user_id].to_i != @task.user_id.to_i
          updated_params[:status] = "pending"
        end
      end
      return updated_params
    end

    def upload_files
      @uploads = []
      return true unless params[:uploads]
      params[:uploads].each do |upload| 
        new_upload = @task.uploads.create(:file => upload)
        @uploads << new_upload
      end
      return (@uploads.any? { |u| u.errors.any? }) ? false : true
    end

    def delete_files
      params[:delete_uploads].each { |id, value| Upload.find(id).destroy! if value == 'true' }
    end

    def delete_new_uploads
      @uploads.each { |upload| upload.destroy } unless @uploads.blank?
    end

    def get_upload_errors
      errors = Hash.new
      @uploads.each { |upload| errors[upload.file_file_name] = upload.errors if upload.errors.any? } unless @uploads.blank?
      errors
    end
end
