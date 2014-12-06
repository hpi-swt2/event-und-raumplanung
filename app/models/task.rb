class Task < ActiveRecord::Base
  include DateTimeAttribute
  
  belongs_to :event
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  belongs_to :user

  date_time_attribute :deadline
  validate :deadline_cannot_be_in_the_past


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

  def deadline_cannot_be_in_the_past
      errors.add(:deadline, "can't be in the past") if deadline && deadline < Date.today
  end
   

  def send_notification
	  UserMailer.user_assigned_to_task_email(user, self).deliver
  end
end
