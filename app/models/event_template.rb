class EventTemplate < ActiveRecord::Base
  validates :name, presence: true
  has_many :rooms, dependent: :nullify
end
