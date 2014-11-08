class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	has_many :user
end
