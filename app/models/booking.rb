class Booking < ActiveRecord::Base
  belongs_to :event
  belongs_to :room
  
  def self.events_for_today_for_room(room_id)
	events_for_today_for_room = self.where("bookings.room_id = room_id and bookings.start >= ? and bookings.start <= ?", DateTime.now.beginning_of_day, DateTime.now.end_of_day)
	
	return events_for_today_for_room.select(:name, :start, :end).as_json
	
  end
  
  def as_json(options = {})
	{
		:title => self.name,
		:start => self.start.utc.iso8601,
		:end => self.end.utc.iso8601
	}
  end
  
end
