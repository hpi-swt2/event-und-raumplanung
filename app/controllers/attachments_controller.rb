class AttachmentsController < ApplicationController
  respond_to :html
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  def index
    @attachments = Attachment.where(task_id: params[:task_id])
    respond_to do |format|
        format.js
    end
  end

  def show
    respond_with(@attachment)
  end

  def new
    @attachment = Attachment.new
    respond_with(@attachment)
  end

  def edit
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.save
    respond_with(@attachment)
  end

  def update
    @attachment.update(attachment_params)
    respond_with(@attachment)
  end

  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    def attachment_params
      params.require(:attachment).permit(:title, :url, :task_id)
    end
end
