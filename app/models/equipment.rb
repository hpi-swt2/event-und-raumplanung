class Equipment < ActiveRecord::Base
  belongs_to :room

  filterrific(
    filter_names: [
      :equipment_name,
      :rooms,
      :category
    ]
  )
  scope :equipment_name, lambda { |name|
    where('name = ?', name)
  }
  scope :rooms, lambda { |room|
  	
    room_id = Room.find_by_name(room)
    where('room_id = ?', room_id)
  }

  scope :category, lambda { |category|
    if category != 'Alle Kategorien'
      where('category = ?', category)
    end
  }
end
