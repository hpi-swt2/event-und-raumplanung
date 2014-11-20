# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
room = Room.new(name: 'Seminarraum H-2.59', size: 15)
Equipment.create([{ name: 'Beamer', description: '4:3 Beamer', category: 'BEAMER', room: room }, { name: 'WLAN', description: '3 G', category: 'WLAN', room: room }])
Booking.create([{ name: 'HCI II', description: 'Vorlesung', start: DateTime.now, end: DateTime.now.advance(hours: 3), room: room }, { name: 'HCI II', description: 'Vorlesung', start: DateTime.now.advance(days: 2), end: DateTime.now.advance(days: 2, hours: 3), room: room }])