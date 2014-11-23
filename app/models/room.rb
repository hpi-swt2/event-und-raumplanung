class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'  
  has_and_belongs_to_many :properties, :class_name => 'RoomProperty'
  has_many :events

  def upcoming_events
    return self.events.where(['start_date > ?', Date.today]).order('start_date asc')
  end

  def list_properties
    return self.properties.all.map{ |p| p.name }.join(', ')
  end

end
