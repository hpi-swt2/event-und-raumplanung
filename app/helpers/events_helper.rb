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
		return event.rooms.map(&:name).to_sentence
	end 

	def get_name_of_original_event event 
		return 'Event ' + event.event.name
	end

end
