class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)
  end

  def update
  end

  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to edit_task_path @upload.task_id }
      format.json { head :no_content }
    end
  end

  private
    def set_upload
      @upload = Upload.find(params[:id])
    end

    def upload_params
      params[:upload].permit(:file)
    end
end
