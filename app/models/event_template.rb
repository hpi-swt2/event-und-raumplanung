class EventTemplate < ActiveRecord::Base
  validates :name, presence: true
  has_many :rooms, dependent: :nullify

  scope :from_user, lambda { |user_id|
    where("user_id = ?",user_id)
  }
end
