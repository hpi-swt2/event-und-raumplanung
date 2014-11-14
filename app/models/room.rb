class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'  
  has_and_belongs_to_many :properties, :class_name => 'RoomProperty'

  def upcoming_events
    return self.bookings.where(['start > ?', DateTime.now]).order('start asc')
  end

end
