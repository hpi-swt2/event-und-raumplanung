class GenericEventsController < ApplicationController
  protected
  	def get_instance_variable
  	  @instance_variable = instance_variable_get("@#{controller_name.singularize}")
  	end 

  	def get_model 
  	  @model = controller_name.classify.constantize
  	end

	def current_user_id
      current_user.id
  end

	def new 
	  @instance_variable = @model.new
	  @instance_variable.setDefaultTime
  	instance_variable_set("@#{controller_name.singularize}", @instance_variable)
	end 	

	def create
	  params = (method "#{controller_name.singularize + '_params'}").call
	  @instance_variable = @model.new(params)
    @instance_variable.user_id = current_user_id
    instance_variable_set("@#{controller_name.singularize}", @instance_variable)
    respond_to do |format|
      if @instance_variable.save
        format.html { redirect_to @instance_variable, notice: t('notices.successful_create', :model => @model.model_name.human) } # redirect to overview
        format.json { render :show, status: :created, location: @instance_variable }
      else
        format.html { render :new }
        format.json { render json: @instance_variable.errors, status: :unprocessable_entity }
      end
    end
  end	

  def update
    params = (method "#{controller_name.singularize + '_params'}").call
    respond_to do |format|
      if @update_result
        conflicting_events = @instance_variable.check_vacancy params[:original_event_id], params[:room_ids]
        if conflicting_events.size > 1 ## this event is also in the returned list
          format.html { redirect_to @instance_variable, alert: t('alert.conflict_detected', :model => @model.model_name.human) }
        else 
          format.html { redirect_to @instance_variable, notice: t('notices.successful_update', :model => @model.model_name.human) }
          format.json { render :show, status: :ok, location: @instance_variable }
        end
      else
        format.html {render :edit}
        format.json { render json: @instance_variable.errors, status: :unprocessable_entity }
      end
    end
 	end
 	
 	def destroy
 	  @instance_variable.destroy
      respond_to do |format|
      	format.html { redirect_to url_for(@instance_variable), notice: t('notices.successful_destroy', :model => @model.model_name.human) }
        format.json { head :no_content }
      end
   	end
end 