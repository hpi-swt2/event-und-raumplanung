class Task < ActiveRecord::Base

  include RankedModel
  include DateTimeAttribute

  belongs_to :event
  belongs_to :identity, polymorphic: true
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  has_many :uploads, :dependent => :destroy
  accepts_nested_attributes_for :uploads
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
    group_assignment = false
    if group_assignment
      group_members = []
      group_members.each do |recipient|
        UserMailer.user_assigned_to_task_email(assigner, self, recipient).deliver  
      end
    else
      UserMailer.user_assigned_to_task_email(assigner, self, user).deliver
    end
  end

  def send_notification_to_previously_assigned_user(previousUser, assigner)
    group_assignment = false
    if group_assignment
      group_members = []
      group_members.each do |recipient|
        UserMailer.user_assignment_removed_email(assigner, recipient, self).deliver  
      end
    else
      UserMailer.user_assignment_removed_email(assigner, previousUser, self).deliver
    end
  end
end
