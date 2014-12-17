class Equipment < ActiveRecord::Base
  belongs_to :room

  filterrific(
    filter_names: [
      :equipment_name,
      :search_for_name
    ]
  )
  scope :equipment_name, lambda { |name|
    where('name = ?', name)
  }
  scope :search_for_name, lambda { |room|
  	room_id= Room.where(["name = ?", room]).id
  	puts(room_id)

    where('room_id = ?', room_id)
  }
end
