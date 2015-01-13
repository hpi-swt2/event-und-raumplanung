class Task < ActiveRecord::Base

  include RankedModel
  include DateTimeAttribute

  belongs_to :event
  belongs_to :event_template
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  belongs_to :user
  validates_presence_of :name
  ranks :task_order, :with_same => :event_id
  date_time_attribute :deadline
  validate :deadline_cannot_be_in_the_past


  def deadline_cannot_be_in_the_past
    errors.add(:deadline, "can't be in the past") if deadline && deadline <= Date.today
  end

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
