class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	has_and_belongs_to_many :users
	has_many :rooms
  has_many :permissions, :as => :permitted_entity, :dependent => :destroy

  def has_permission(category, room = nil)
    return self.permissions.for_category(category).any? { |permission|
      permission.room == room or permission.room.nil?
    }
  end

  def has_any_permission(category)
    return !self.permissions.for_category(category).empty?
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
end
