# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.create([
  { name: 'Mathe 1',
    start_date: '2014-12-02',
    status: 'In Bearbeitung',
    user_id: ''},
  { name: 'TI',
    start_date: '2014-12-05',
    status: 'In Bearbeitung',
    user_id: ''},
  { name: 'SSK',
    start_date: '2014-12-15',
    status: 'In Bearbeitung',
    user_id: ''},
  { name: 'Scrum Meeting',
    start_date: '2014-12-10',
    status: 'Approved',
    user_id: ''},
  { name: 'Mathe 1',
    start_date: '2014-12-12',
    status: 'Approved',
    user_id: ''}
])