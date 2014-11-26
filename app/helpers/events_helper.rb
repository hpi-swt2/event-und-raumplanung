module EventsHelper

def trimDescription(description)
		if description.length > 60
			return description[0, 55] + "[...]"
		end
		return description
	end 

def nl2br(s)
  s.gsub(/\n/, '<br>')
end

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
