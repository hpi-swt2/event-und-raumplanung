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
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

event = Event.create({name: 'Klubtreffen',
					description: 'Klubtreffen des PR-Klubs',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 12,
					user_id: 1})

another_event = Event.create({name: 'Vorlesung',
					description: 'A description',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 80,
					user_id: 1})

Task.create({name: 'An accepted Task', 
			description: 'This is an accepted task.',
			event_id: event.id,
			user_id: 1,
			status: 'accepted'})

Task.create({name: 'Another accepted Task', 
			description: 'This is a accepted task which is already done.',
			event_id: another_event.id,
			user_id: 1,
			status: 'accepted',
			done: true })

Task.create({name: 'A pending Task', 
			description: 'This is a pending task.',
			event_id: event.id,
			user_id: 1,
			status: 'pending'})

Task.create({name: 'A second pending Task', 
			description: 'This is another pending task.',
			event_id: another_event.id,
			user_id: 1,
			status: 'pending'})

Task.create({:name => 'A Task', :description => 'This is a task.', :status => "not_assigned"})

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
## Create Users
user2 = User.create(email: 'Max.Mustermann.' + DateTime.now.to_s + '@example.com', username: "maxe1992", identity_url: 'http://example.com/Max.Mustermann.' + DateTime.now.to_s)
user3 = User.create(email: 'Erika.Musterfrau.' + DateTime.now.to_s + '@example.com', username: "eri1942", identity_url: 'http://example.com/Erika.Musterfrau.' + DateTime.now.to_s)

#
# Create Event

event1 = Event.create(name: "Weihnachtsfeier", description: "Details zur Weihnachtsfeier 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room1.id, rooms: [room1], is_private: false, is_important: true,  status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event2 = Event.create(name: "Sommerfest", description: "Details zur Sommerfest 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room2.id, rooms: [room2], is_private: false, is_important: false,  status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event3 = Event.create(name: "Tribute von Panem", description: "Details zum Event Tribute von Panem 2015", participant_count: 10, created_at: "2015-11-20 12:20:20", user_id: 1, room_id: room3.id, rooms: [room3], is_private: true, is_important: false,  status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event4 = Event.create(name: 'Mathe', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 1, room_id: room13.id, rooms: [room13], is_private: false, is_important: false,  status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event5 = Event.create(name: 'PT', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: 1, room_id: room12.id, rooms: [room12], is_private: false, is_important: true,  status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event6 = Event.create(name: 'POIS', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user2.id, room_id: room7.id, rooms: [room7], is_private: false, is_important: false,  status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event7 = Event.create(name: 'ISEC', description: 'Vorlesung', participant_count: 20, created_at: DateTime.now, user_id: user3.id, room_id: room12.id, rooms: [room12], is_private: false, is_important: false,  status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))
event8 = Event.create(name: 'HCI II', description: 'Vorlesung', participant_count: 40, created_at: DateTime.now, user_id: user3.id, room_id: room13.id, rooms: [room13], is_private: false, is_important: true,  status: "In Bearbeitung", starts_at: DateTime.now, ends_at: DateTime.now.advance(hours: 2), start_date: Date.today, end_date: Date.today, start_time: Time.current, end_time: Time.current.advance(hours: 2))

#
# Create Booking
booking1 = Booking.create(name: 'HCI II', description: 'Vorlesung 1', start: DateTime.now, end: DateTime.now.advance(hours: 3), event: event8, room: room13)
booking2 = Booking.create(name: 'HCI II', description: 'Vorlesung 2', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), event: event8, room_id: room13.id)
booking3 = Booking.create(name: 'Connect Club Treffen', description: 'Clubtreffen', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room_id: room3.id)
booking4 = Booking.create(name: 'Vorlesung PT', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event: event5, room_id: room12.id)
booking5 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event: event6, room_id: room7.id)
booking6 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 14, min: 30), event: event7, room_id: room1.id)
booking7 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event: event7, room_id: room12.id)
booking8 = Booking.create(name: 'Vorlesung Mathe', description: 'Vorlesung 1', start: DateTime.now.change(hour: 11), end: DateTime.now.change(hour: 12, min: 30), event: event4, room_id: room13.id)
booking9 = Booking.create(name: 'Vorlesung PT', description: 'Vorlesung 2', start: DateTime.now.change(hour: 13, min: 30), end: DateTime.now.change(hour: 15), event: event5, room_id: room12.id)
booking10 = Booking.create(name: 'Vorlesung POIS', description: 'Vorlesung 3', start: DateTime.now.change(hour: 13, min: 30), end: DateTime.now.change(hour: 15), event: event6, room_id: room7.id)
booking11 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 8), end: DateTime.now.advance(days: 1).change(hour: 9), event: event7, room_id: room12.id)
booking12 = Booking.create(name: 'Vorlesung ISEC', description: 'Vorlesung 3', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 15), event: event7, room_id: room12.id)
booking13 = Booking.create(name: 'Vorlesung Mathe', description: 'Vorlesung 2', start: DateTime.now.advance(days: 1).change(hour: 13, min: 30), end: DateTime.now.advance(days: 1).change(hour: 15), event: event4, room_id: room13.id)
