class Group < Assignable
	validates_uniqueness_of :name
	validates :name, presence: true
	has_and_belongs_to_many :users
	has_many :rooms
end
