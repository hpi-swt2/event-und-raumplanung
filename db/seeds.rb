# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({identity_url: 'http://example.com/test.user', 
					email: 'test.user@example.com'})

event = Event.create({name: 'Eventname',
					description: 'A description',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 12,
					user_id: user.id})

Task.create({name: 'A Task', 
			description: 'This is a task.',
			event_id: event.id,
			user_id: user.id,
			status: 'pending'})