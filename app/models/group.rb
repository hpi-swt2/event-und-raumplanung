class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	has_and_belongs_to_many :users
	has_many :rooms
  has_many :permissions, :as => :permitted_entity

  def has_permission(category, room = nil)
    return self.permissions.for_category(category).any? { |permission|
      permission.room == room or permission.room.nil?
    }
  end
end
