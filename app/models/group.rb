class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	  has_many :memberships
	  has_many :users, through: :memberships
	has_many :rooms
	has_many :tasks, as: :identity

	def is_group
		true
    end
end
