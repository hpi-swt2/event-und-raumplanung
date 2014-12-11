class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: [:destroy]

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)
  end

  def destroy
    @upload.destroy
    render nothing: true
  end

  private
    def set_upload
      @upload = Upload.find(params[:id])
    end

    def upload_params
      params[:upload].permit(:file)
    end
end
