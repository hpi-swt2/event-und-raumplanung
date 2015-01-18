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
end
