class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'
  has_many :events

  def upcoming_events
    return self.events.where(['start_date > ?', Date.today]).order('start_date asc')
  end

end
