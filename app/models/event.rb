class Event < ActiveRecord::Base
  has_many :bookings
  has_many :tasks
  belongs_to :user
end
