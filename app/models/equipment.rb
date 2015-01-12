class Equipment < ActiveRecord::Base
  belongs_to :room

  validates :name, presence: true
  validates :category, presence: true
  

  filterrific(
    filter_names: [
      :equipment_name,
      :rooms,
      :category
    ]
  )
  scope :equipment_name, lambda { |name|
    terms = name.downcase.split(/\s+/)
    terms = terms.map { |e| ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')}
    where( terms.map { |term| "LOWER(equipment.name) LIKE ?"}.join(' AND '), *terms.map { |e| [e]} )
  }
  scope :rooms, lambda { |name|
    terms = name.downcase.split(/\s+/)
    terms = terms.map { |e| ('%'+e.gsub('*', '%') + '%').gsub(/%+/, '%')}
    
    room_ids = Room.where( terms.map { |term| "LOWER(rooms.name) LIKE ?"}.join(' AND '), *terms.map { |e| [e]} ).select("id")

    
    #room_id = Room.find_by_name("A-%")
    
    where('room_id IN (?)', room_ids) 
  }

  scope :category, lambda { |category|
    if category != 'Alle Kategorien'
      where('category = ?', category)
    end
  }
end
