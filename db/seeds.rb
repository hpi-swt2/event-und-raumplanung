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

#
# Create Equipment
equipment = Equipment.create(id: 1, name: 'Beamer HD 124794', description: 'Ein fest installierter Beamer mit HD', room_id: 1, category: 'Beamer')
equipment = Equipment.create(id: 2, name: 'Whiteboard 23', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: 1, category: 'Whiteboard')
equipment = Equipment.create(id: 3, name: 'Beamer HD 12474324', description: 'Ein fest installierter Beamer mit HD', room_id: 2, category: 'Beamer')
equipment = Equipment.create(id: 4, name: 'Beamer HD 124734', description: 'Ein fest installierter Beamer mit HD', room_id: 3, category: 'Beamer')
equipment = Equipment.create(id: 5, name: 'Beamer HD 12474234', description: 'Ein fest installierter Beamer mit HD', room_id: 4, category: 'Beamer')
equipment = Equipment.create(id: 6, name: 'Beamer HD 12424424', description: 'Ein fest installierter Beamer mit HD', room_id: 5, category: 'Beamer')

#
# Create Event
#
# Booking

Booking.create([{ name: 'HCI II', description: 'Vorlesung', start: DateTime.now, end: DateTime.now.advance(hours: 3), room: room }, { name: 'HCI II', description: 'Vorlesung', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room: room }])