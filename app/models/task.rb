class Task < ActiveRecord::Base
  belongs_to :event
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  belongs_to :user

  def update_and_send_notification(task_params)
	  assign_attributes(task_params)
	  if valid?
	    if user_id_changed? and user_id?
			send_notification
	    end
	    save
	    return true
	  else
	    return false
	  end
  end

  def send_notification
	UserMailer.user_assigned_to_task_email(user, self).deliver
  end
end
