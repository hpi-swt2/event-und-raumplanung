class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :room

  scope :approved, -> { where event: Event.approved.pluck(:id) }

end
