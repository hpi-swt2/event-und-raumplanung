class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'
  
  def bookings_for_today
	#Booking.where(room: ?).where(:conditions => ['start.to_date = Date.today']).order(start :asc)
  end
end
