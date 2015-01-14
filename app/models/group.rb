class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	has_and_belongs_to_many :users
	has_many :rooms
	has_many :tasks, as: :identity

	def is_group
		true
    end
end
