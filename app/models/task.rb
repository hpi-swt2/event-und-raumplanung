class Task < ActiveRecord::Base
  include RankedModel

  belongs_to :event
  belongs_to :user
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  has_many :uploads, :dependent => :destroy
  accepts_nested_attributes_for :uploads
  validates_presence_of :name
  ranks :task_order

  def update_and_send_notification(task_params, assigner)
    previousUser = user
    assign_attributes(task_params)
    if valid?
      if user_id_changed?
        unless previousUser.nil?
          send_notification_to_previously_assigned_user(previousUser, assigner)
        end
        if user_id?
      	  send_notification_to_assigned_user(assigner)
        end
      end
      save
      return true
    else
      return false
    end
  end

  def send_notification_to_assigned_user(assigner)
    UserMailer.user_assigned_to_task_email(assigner, self).deliver
  end

  def send_notification_to_previously_assigned_user(previousUser, assigner)
    UserMailer.user_assignment_removed_email(assigner, previousUser, self).deliver
  end
end
