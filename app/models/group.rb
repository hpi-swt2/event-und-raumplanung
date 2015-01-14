class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	  has_many :memberships
	  has_many :users, through: :memberships
	has_many :rooms
end
