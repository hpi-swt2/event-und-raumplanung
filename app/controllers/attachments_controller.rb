class AttachmentsController < ApplicationController
  respond_to :json

  def index
    @attachments = Attachment.where(task_id: params[:task_id])
  end

  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.save
    respond_with(@attachment)
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def attachment_params
      params.require(:attachment).permit(:title, :url, :task_id)
    end
end
