class Group < ActiveRecord::Base
	validates_uniqueness_of :name
	validates :name, presence: true
	has_and_belongs_to_many :users
end
