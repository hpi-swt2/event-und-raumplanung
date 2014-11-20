module EventsHelper

def concat_rooms(event)
	room_str = '' 
	event.rooms.each do |room| 
		if room_str == ''
			room_str += room.name
		else 
			room_str +=  ', ' + room.name
		end 
	end 
	return room_str
end 
end
