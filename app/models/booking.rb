class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :room

  scope :approved, -> { where event: Event.approved }
  scope :start_at_day, lambda { |date| where 'start BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day }

end
