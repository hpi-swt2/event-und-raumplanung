class Room < ActiveRecord::Base
  has_many :bookings
  has_many :equipment # The plural of 'equipment' is 'equipment'  
  has_and_belongs_to_many :properties, :class_name => 'RoomProperty'
  has_and_belongs_to_many :events

  def upcoming_events
    return self.events.where(['ends_at >= ?', Date.today]).order('starts_at asc')
  end

  def list_properties
    return self.properties.all.map{ |p| p.name }.join(', ')
  end

  def nearby_rooms(closeness)
    if self.name.include? "-"
      building = self.name.str[0]
      floor = self.name.str[2]
      number = self.name.str[4..-1]
      refield = Array.new

      if closeness == 1
        @rooms.each do |room|
          if building == room.name.str[0] && floor == room.name.str[2] && ( number.to_i - room.name.str[4..-1].to_i == 1 || room.name.str[4..-1].to_i - number.to_i == 1)
            refield << room.id
          end
        end
      end

      if closeness == 2
        @rooms.each do |room|
          if building == room.name.str[0] && floor == room.name.str[2]
            refield << room.id
          end
        end
      end

      if closeness == 3
        @rooms.each do |room|
          if building == room.name.str[0]
            refield << room.id
          end
        end
      end

    else
       @rooms.each do |room|
          if room.name.str[0..1] == "HS" && !(room.name.str[3] = self.name.str[3])
            refield << room.id
          end
        end
    end

    return refield

  end

end
