# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


#
# Create Rooms
room = Room.create(id: 1, name: 'H-E.1', size: 30)
room = Room.create(id: 2, name: 'H-E.2', size: 30)
room = Room.create(id: 3, name: 'H-C.1', size: 60)
room = Room.create(id: 4, name: 'H-C.2', size: 10)
room = Room.create(id: 5, name: 'HS 1', size: 100)
room = Room.create(id: 6, name: 'room', size: 5)

#
# Create Equipment
equipment = Equipment.create(id: 1, name: 'Beamer HD 124794', description: 'Ein fest installierter Beamer mit HD', room_id: 1, category: 'Beamer')
equipment = Equipment.create(id: 2, name: 'Whiteboard 23', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: 1, category: 'Whiteboard')
equipment = Equipment.create(id: 3, name: 'Beamer HD 12474324', description: 'Ein fest installierter Beamer mit HD', room_id: 2, category: 'Beamer')
equipment = Equipment.create(id: 4, name: 'Beamer HD 124734', description: 'Ein fest installierter Beamer mit HD', room_id: 3, category: 'Beamer')
equipment = Equipment.create(id: 5, name: 'Beamer HD 12474234', description: 'Ein fest installierter Beamer mit HD', room_id: 4, category: 'Beamer')
equipment = Equipment.create(id: 6, name: 'Beamer HD 12424424', description: 'Ein fest installierter Beamer mit HD', room_id: 5, category: 'Beamer')
equipment = Equipment.create(id: 7, name: 'Beamer HD 1247912', description: 'Ein fest installierter Beamer mit HD', room_id: 1, category: 'Beamer')
equipment = Equipment.create(id: 8, name: 'Whiteboard 234', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: 1, category: 'Whiteboard')

#
#Create room_properties
prop = RoomProperty.create(name: "Catering", room_id: 2)
prop = RoomProperty.create(name: "barrierefrei", room_id: 1)
prop = RoomProperty.create(name: "Catering", room_id: 3)
prop = RoomProperty.create(name: "barrierefrei", room_id: 3)
prop = RoomProperty.create(name: "breite Türen", room_id: 3)


#
# Create Event
event = Event.create(name: "Weihnachtsfeier", description: "Details zur Weihnachtsfeier 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: 1, is_private: false, approved: nil, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event = Event.create(name: "Sommerfest", description: "Details zur Sommerfest 2015", participant_count: 10,  status: "In Bearbeitung", created_at: "2015-11-20 12:20:20", user_id: 1, room_id: 1, is_private: false, approved: nil, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")
event = Event.create(name: "Tribute von Panem", description: "Details zum Event Tribute von Panem 2015", participant_count: 10, created_at: "2015-11-20 12:20:20", user_id: 1, room_id: 1, is_private: false, approved: nil, status: "In Bearbeitung", starts_at: "2014-12-26 11:46:01", ends_at: "2014-12-26 12:46:01", start_date: "-4711-01-01", start_time: "2000-01-01 12:46:37", end_date: "-4711-01-01", end_time: "2000-01-01 12:46:37")

#
# createBooking
booking = Booking.create([{ name: 'HCI II', description: 'Vorlesung', start: DateTime.now, end: DateTime.now.advance(hours: 3), room: room }, { name: 'HCI II', description: 'Vorlesung', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room: room }])
booking = Booking.create(name: 'Connect Club Treffen', description: 'Clubtreffen', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room: room)
