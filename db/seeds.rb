# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

#
## Delete old records from database
delete_old_records = false
if delete_old_records
	Room.delete_all
	Equipment.delete_all
	Event.delete_all
	Booking.delete_all
end

#
# Create Rooms
room1 = Room.create(name: 'A-1.1', size: 28)
room2 = Room.create(name: 'A-1.2', size: 39)
room3 = Room.create(name: 'A-2.1', size: 30)
room4 = Room.create(name: 'A-2.2', size: 31)
room5 = Room.create(name: 'D-E.10', size: 20)
room6 = Room.create(name: 'D-E.9', size: 21)
room7 = Room.create(name: 'H-2.57', size: 40)
room8 = Room.create(name: 'H-2.58', size: 24)
room9 = Room.create(name: 'H-E.51', size: 44)
room10 = Room.create(name: 'H-E.52', size: 20)
room11 = Room.create(name: 'HS 1', size: 200)
room12 = Room.create(name: 'HS 2', size: 100)
room13 = Room.create(name: 'HS 3', size: 99)

#
# Create Equipment
equipment1 = Equipment.create(name: 'Beamer HD 124794', description: 'Ein fest installierter Beamer mit HD', room_id: room1.id, category: 'Beamer')
equipment2 = Equipment.create(name: 'Whiteboard 23', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room1.id, category: 'Whiteboard')
equipment3 = Equipment.create(name: 'Beamer HD 12474324', description: 'Ein fest installierter Beamer mit HD', room_id: room2.id, category: 'Beamer')
equipment4 = Equipment.create(name: 'Beamer HD 124734', description: 'Ein fest installierter Beamer mit HD', room_id: room3.id, category: 'Beamer')
equipment5 = Equipment.create(name: 'Beamer HD 12474234', description: 'Ein fest installierter Beamer mit HD', room_id: room4.id, category: 'Beamer')
equipment6 = Equipment.create(name: 'Beamer HD 12424424', description: 'Ein fest installierter Beamer mit HD', room_id: room5.id, category: 'Beamer')
equipment7 = Equipment.create(name: 'Beamer HD 1247912', description: 'Ein fest installierter Beamer mit HD', room_id: room6.id, category: 'Beamer')
equipment8 = Equipment.create(name: 'Whiteboard 234', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room7.id, category: 'Whiteboard')

#
# Create Event
event1 = Event.create(name: "Weihnachtsfeier", description: "Details zur Weihnachtsfeier 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room1.id, is_private: false, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event2 = Event.create(name: "Sommerfest", description: "Details zur Sommerfest 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room2.id, is_private: false, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event3 = Event.create(name: "Tribute von Panem", description: "Details zum Event Tribute von Panem 2015", participant_count: 10, created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room3.id, is_private: false, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event4 = Event.create(name: 'Mathe', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 1, room_id: room11.id, is_private: false, status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event5 = Event.create(name: 'PT', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 1, room_id: room12.id, is_private: false, status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event6 = Event.create(name: 'POIS', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 2, room_id: room13.id, is_private: false, status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event7 = Event.create(name: 'ISEC', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 3, room_id: room11.id, is_private: false, status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event8 = Event.create(name: 'HCI II', description: 'Vorlesung', participant_count: 40, created_at: DateTime.now, user_id: 3, room_id: room12.id, is_private: false, status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))

#
# Create Booking
booking1 = Booking.create(name: 'HCI II', description: 'Vorlesung 1', start: DateTime.now, end: DateTime.now.advance(hours: 3), event_id: event8.id, room_id: room1.id)
booking2 = Booking.create(name: 'HCI II', description: 'Vorlesung 2', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), event_id: event8.id, room_id: room2.id)
booking3 = Booking.create(name: 'Connect Club Treffen', description: 'Clubtreffen', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room_id: room3.id)
booking4 = Booking.create(name: 'Vorlesung PT', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event_id: event5.id, room_id: room11.id)
booking5 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event_id: event6.id, room_id: room12.id)
booking6 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 14, min: 30), event_id: event6.id, room_id: room12.id)
booking7 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event_id: event7.id, room_id: room13.id)
booking8 = Booking.create(name: 'Vorlesung Mathe', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event_id: event4.id, room_id: room11.id)
booking9 = Booking.create(name: 'Vorlesung PT', description: 'Vorlesung 2', start: DateTime.now.change(hour: 13, min: 30), end: DateTime.now.change(hour: 15), event_id: event5.id, room_id: room11.id)
booking10 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 3', start: DateTime.now.change(hour: 13, min: 30), end: DateTime.now.change(hour: 15), event_id: event6.id, room_id: room1.id)
booking11 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 8), end: DateTime.now.advance(days: 1).change(hour: 9), event_id: event7.id, room_id: room12.id)
booking12 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 3', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 15), event_id: event7.id, room_id: room13.id)
booking13 = Booking.create(name: 'Vorlesung Mathe', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 15), event_id: event4.id, room_id: room12.id)