class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'

  def upcoming_events
    return self.bookings.where(['start > ?', DateTime.now]).order('start asc')
  end

end
