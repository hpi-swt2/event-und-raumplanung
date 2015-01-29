######################################################################################################
#
# This file contains seed data for the acceptance tests, please do only alter with caution
#
#######################################################################################################


#
## Room seed
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
## Event seed
event = Event.create({name: 'Klubtreffen',
					description: 'Klubtreffen des PR-Klubs',
					starts_at: Date.today + 1,
					ends_at: Date.today + 1,
					participant_count: 12,
					user_id: 1,
					room_id: room1.id,
					rooms: [room1]})
event2 = Event.create({name: 'AdminEvent',
					description: 'details for an event of admins',
					starts_at: Date.today + 2,
					ends_at: Date.today + 2,
					participant_count: 200,
					user_id: 3,
					room_id: room1.id,
					rooms: [room1]})

#
## Task seed
Task.create({name: 'An accepted Task', 
			description: 'This is an accepted task.',
			event_id: event.id,
			identity_id: 1,
			status: 'accepted'})

Task.create({:name => 'A Task', 
	         :description => 'This is a task.', 
	         :status => "not_assigned"})

#
## Permission seed
permission1 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 1, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission2 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 2, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission3 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 3, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission4 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 4, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission5 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 5, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission6 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 6, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")
permission7 = Permission.create(room_id: nil, permitted_entity_id: 3, permitted_entity_type: "User", category: 7, created_at: "2015-01-28 20:22:57", updated_at: "2015-01-28 20:22:57")

#
##  Equipment seed
equipment1 = Equipment.create(name: 'Beamer HD 124794', description: 'Ein fest installierter Beamer mit HD', room_id: room1.id, category: 'Beamer')
equipment2 = Equipment.create(name: 'Whiteboard 23', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room1.id, category: 'Whiteboard')
equipment3 = Equipment.create(name: 'Beamer HD 12474324', description: 'Ein fest installierter Beamer mit HD', room_id: room2.id, category: 'Beamer')
equipment4 = Equipment.create(name: 'Beamer HD 124734', description: 'Ein fest installierter Beamer mit HD', room_id: room3.id, category: 'Beamer')
equipment5 = Equipment.create(name: 'Beamer HD 12474234', description: 'Ein fest installierter Beamer mit HD', room_id: room4.id, category: 'Beamer')
equipment6 = Equipment.create(name: 'Beamer HD 12424424', description: 'Ein fest installierter Beamer mit HD', room_id: room5.id, category: 'Beamer')
equipment7 = Equipment.create(name: 'Beamer HD 1247912', description: 'Ein fest installierter Beamer mit HD', room_id: room6.id, category: 'Beamer')
equipment8 = Equipment.create(name: 'Whiteboard 234', description: 'Ein fest installierter Whiteboard zum Brainstorming', room_id: room7.id, category: 'Whiteboard')

#
## create Comments
comment = Comments.create(user_id: 1, content: "Ich will MEHR PIZZA!!!", created_at: "2014-12-26 13:37:42", event_id: 1)
comment = Comments.create(user_id: 1, content: "Ich will NOCH MEHR PIZZA!!!", created_at: "2014-12-26 15:37:42", event_id: 2)

#
##  User seed
#user1 = User.create(email: "test_admin@example.com", username: "test_admin", encrypted_password: "", status: nil, reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, identity_url: nil, student: nil, fullname: "", office_location: "", office_phone: "", mobile_phone: "", language: "German", email_notification: true, firstlogin: true)
user2 = User.create(email: 'Max.Mustermann.' + DateTime.now.to_s + '@example.com', username: "maxe1992", identity_url: 'http://example.com/Max.Mustermann.' + DateTime.now.to_s)
user3 = User.create(email: 'Erika.Musterfrau.' + DateTime.now.to_s + '@example.com', username: "eri1942", identity_url: 'http://example.com/Erika.Musterfrau.' + DateTime.now.to_s)
