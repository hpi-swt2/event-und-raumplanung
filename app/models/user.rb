class User < ActiveRecord::Base
  has_many :tasks, as: :identity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  devise :openid_authenticatable, :rememberable

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :favorites
  has_many :permissions, :as => :permitted_entity, :dependent => :destroy

  def is_member_of_group (groupID)
    return Group.find(groupID).users.include?(self)
  end

  def is_leader_of_group (groupID)
    if self.is_member_of_group(groupID)
      return self.memberships.select{|membership| membership.group_id == groupID}.first.isLeader
    else
      return false
    end
  end
 
  def has_permission(category, room = nil)
    if (self.permissions.for_category(category).any? { |permission|
      permission.room == room or permission.room.nil?
    })
      return true
    end
    return (self.groups.any? { |group| group.has_permission(category, room) })
  end

  def has_any_permission(category)
    if (!self.permissions.for_category(category).empty?)
      return true
    end
    return (self.groups.any? { |group| group.has_any_permission(category) })
  end

  def permit(category, room = nil)
    self.permissions << Permission.new(category: category, room: room)
  end

  def unpermit(category, room = nil)
    self.permissions.find_by(category: Permission::categories[category], room: room).try(:destroy)
  end

  def unpermit_all(category)
    self.permissions.find_all{ |permission| permission.category == category}.each do |permission|
      permission.destroy
    end
  end

  def self.build_from_email(email)
    User.new(:email => email)
  end

  # similar to Group#name
  def name
    return username
  end

  def is_group
    false
  end

  def display_name
    if !self.fullname.blank?
      self.fullname
    else
      self.username
    end
  end
end
