class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :set_done, :destroy, :accept, :decline, :upload_file]
  before_action :set_for_event_template, only: [:edit]
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
    @event = Event.find(@task.event_id)
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @assignable_entities = Group.all
    @assignable_entities.concat(User.all)
    if params[:event_id].present?
      @task.event_id = params[:event_id]
      @for_event_template = false
      @event_field_readonly = :true
      authorize! :create, @task
      @task.deadline = @task.event.starts_at.strftime("%d/%m/%Y")
    else
      unless params[:event_template_id].blank?
        @task.event_template_id = params[:event_template_id]
        @for_event_template = true
      end
    end
  end

  # GET /tasks/1/edit
  def edit
    if @task.identity_type && @task.identity_id
      if @task.identity_type == 'User'
        @identity_name = User.find(@task.identity_id).username
      else
        @identity_name = Group.find(@task.identity_id).name + " (#{t('groups.group')})"
      end
    else
      @identity_name = ''
    end
    authorize! :edit, @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(set_status task_params_with_attachments)
    @task.creator = current_user
    @task.done = false
    if identity_params
      @task.identity_id =  identity_params[:id]
      @task.identity_type =  identity_params[:type]
    end

    authorize! :create, @task
    
    respond_to do |format|
      if @task.save && upload_files
        @task.send_notification_to_assigned_user(current_user) if @task.identity
        create_activity(@task)
        redirection_target = @task.event ? @task.event : @task.event_template
        format.html { redirect_to redirection_target, notice: t('notices.successful_create', :model => Task.model_name.human) }
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
    authorize! :update, @task
    delete_files if params[:delete_uploads]

    if identity_params.blank?
      params[:task][:identity_id] = nil 
      params[:task][:identity_type] = nil
    else 
      params[:task][:identity_id] = identity_params[:id]
      params[:task][:identity_type] = identity_params[:type]
    end 

    current_done_status = @task.done

    respond_to do |format|
      if upload_files && @task.update_and_send_notification((set_status task_params), current_user)
        create_activity(@task) if current_done_status != @task.done
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
      format.html { redirect_to event_path(@task.event_id), notice: t('notices.successful_destroy', :model => Task.model_name.human) }
      format.json { head :no_content }
    end
  end

  def accept
    if @task.identity
      return redirect_to root_path unless can_task_be_accepted?
      @task.identity = current_user if is_member_of_assigned_group?
      @task.status = 'accepted'
      @task.save
    end 
    respond_to do |format| 
      format.html { redirect_to @task }
      format.json { render json: @task }
    end
  end


  def decline
    if @task.identity && (is_member_of_assigned_group? || is_assigned_user?)
      if @task.status == 'accepted'
        flash[:warning] = t('.you_already_accepted_this_task')
        return redirect_to root_path
      else
        @task.status = 'declined'
        @task.save
      end
    else
      flash[:warning] = t('.you_are_not_authorized_to_decline_this_task')
      return redirect_to root_path
    end
    respond_to do |format|
      format.html { redirect_to @task }
      format.json { render json: @task }
    end
  end

  def can_task_be_accepted?
    if @task.status == 'declined'
      flash[:warning] = t('.this_task_was_already_declined')
      return false
    elsif @task.status == 'accepted'
      flash[:warning] = t('.this_task_was_already_accepted_by') + ' ' + @task.identity.name
      return false
    elsif !@task.identity.is_group and @task.identity.id != current_user.id
      flash[:warning] = t('.you_are_not_authorized_to_accept_this_task')
      return false
    end
    true
  end

  def is_member_of_assigned_group?
    @task.identity.is_group && @task.identity.users.include?(current_user)
  end

  def is_assigned_user?
    !@task.identity.is_group && @task.identity.id == current_user.id
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
      params.require(:task).permit(:name, :description, :event_id, :event_template_id, :identity, :identity_type, :identity_id, :user_id, :done, :deadline)
    end

    def task_params_with_attachments
      params.require(:task).permit(:name, :description, :event_id, :event_template_id, :identity, :identity_id, :identity_type, :done, :deadline, :attachments_attributes => [ :title, :url ])
    end

    def task_update_order_params
      params.require(:task).permit(:task_id, :task_order_position)
    end

    def task_set_done_params
      params.require(:task).permit(:done)
    end

    def identity_params
      return nil if params[:task][:identity].blank?
      params[:task][:identity].match(/^(?<type>\w+):(?<id>\d+)$/)          
    end

    def event_id
      return nil unless params[:event]
      params[:event][:event_id] unless params[:event][:event_id].empty?
    end

    def set_status(params)
      updated_params = params
      if @task
        current_identity = @task.identity.nil? ? '' : @task.identity_type + ':' + @task.identity_id.to_s
        if updated_params[:identity].blank?
          updated_params[:status] = 'not_assigned'
        elsif updated_params[:identity] != current_identity
          updated_params[:status] = 'pending'
        end
      else
        if updated_params[:identity].blank?
          updated_params[:status] = 'not_assigned'
        else
          updated_params[:status] = 'pending'
        end
      end
      updated_params.delete(:identity)
      updated_params
    end

    def create_activity(task)
      if task.event_id
        task_info = [task.name, task.done]
        event = Event.find(task.event_id)
        event.activities << Activity.create(:username => current_user.username, 
                                            :action => params[:action],
                                            :controller => params[:controller],
                                            :task_info => task_info)
      end
    end

    def set_for_event_template
      @for_event_template = @task.event_id.blank? ? true : false
    end

    def upload_files
      @uploads = []
      return true unless params[:uploads]
      params[:uploads].each do |upload|
        new_upload = @task.uploads.create(:file => upload)
        @uploads << new_upload
      end
      (@uploads.any? { |u| u.errors.any? }) ? false : true
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
