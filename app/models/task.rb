class Task < ActiveRecord::Base
  before_save :send_mails

  include RankedModel
  include DateTimeAttribute

  belongs_to :event
  belongs_to :identity, polymorphic: true # can be either user or group
  belongs_to :event_template
  has_many :attachments, inverse_of: :task
  accepts_nested_attributes_for :attachments
  has_many :uploads, :dependent => :destroy
  accepts_nested_attributes_for :uploads
  validates_presence_of :name
  ranks :task_order, :with_same => :event_id
  date_time_attribute :deadline
  validate :deadline_cannot_be_in_the_past
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'


  def deadline_cannot_be_in_the_past
    errors.add(:deadline, "can't be in the past") if deadline && deadline <= Date.today
  end

  def identity_changed?
    identity_id_changed? or identity_type_changed?
  end

  def identity_was
    if identity_type_was == "Group"
      Group.find(identity_id_was)
    elsif identity_type_was == "User"
      User.find(identity_id_was)
    else
      nil
    end
  end

  def update_and_send_notification(task_params, assigner)
    previousIdentity = identity
    assign_attributes(task_params)
    if valid?
      if identity_changed?
        unless previousIdentity.nil?
          send_notification_to_previously_assigned_user(previousIdentity, assigner)
        end
        unless identity.nil?
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
    if identity.is_group
      identity.users.each do |recipient|
        UserMailer.user_assigned_to_task_email(assigner, self, recipient, identity).deliver
      end
    else
      UserMailer.user_assigned_to_task_email(assigner, self, identity, nil).deliver
    end
  end

  def send_notification_to_previously_assigned_user(previousIdentity, assigner)
    if previousIdentity.is_group
      previousIdentity.users.each do |recipient|
        UserMailer.user_assignment_removed_email(assigner, recipient, self, previousIdentity).deliver
      end
    else
      UserMailer.user_assignment_removed_email(assigner, previousIdentity, self, nil).deliver
    end
  end

  def send_mails
    if status_changed? and (status == 'accepted' || status == 'declined')
      assigned_group = nil
      previous_identity = identity_was
      if !previous_identity.nil? and previous_identity.is_group
        assigned_group = previous_identity
      end
      UserMailer.assignment_response_notification_email(status == 'accepted', identity, self, assigned_group).deliver
    end
  end
end
