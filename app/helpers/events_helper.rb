module EventsHelper

def concat_rooms(event)
	event.rooms.to_sentence
end 
end
