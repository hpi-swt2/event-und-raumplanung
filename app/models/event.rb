class Event < ActiveRecord::Base
  has_many :bookings
  has_many :tasks
end
