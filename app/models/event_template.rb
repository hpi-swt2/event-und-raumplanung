class EventTemplate < ActiveRecord::Base
  validates :name, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true
  validates :end_time, presence: true

  validate :dates_cannot_be_in_the_past,:start_before_end_date
   def dates_cannot_be_in_the_past

      errors.add(:start_date, "can't be in the past") if start_date && start_date < Date.today
      errors.add(:end_date, "can't be in the past") if end_date && end_date < Date.today
    end
   def start_before_end_date
      errors.add(:start_date, "start has to be before the end") if start_date && end_date && end_date < start_date
   end
end