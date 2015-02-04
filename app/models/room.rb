class Room < ActiveRecord::Base
  include PaginationModule
  
  has_many :bookings
  has_many :equipment, :inverse_of => :room # The plural of 'equipment' is 'equipment' 
  has_many :equipment_requests
  has_and_belongs_to_many :properties, :class_name => 'RoomProperty'
  has_and_belongs_to_many :events
  belongs_to :group

  filterrific(
    default_settings: { sorted_by: 'name_asc', items_per_page: '10' },
    filter_names: [
      :search_query,
      :sorted_by,
      :items_per_page
    ]
  )
  self.per_page = 10

  def upcoming_events
    return self.events.where(['ends_at >= ?', Date.today]).order('starts_at asc')
  end

  def list_properties
    return self.properties.all.map{ |p| p.name }.join(', ')
  end
  scope :items_per_page, lambda { |query|  #workaround 
  }
  scope :search_query, lambda { |query|
    query = query.gsub /(.)/, '*\1'   
    query = query.gsub /([.\s-])(\d)/, '_'
    terms = query.downcase.split(/\s+/)

    terms = terms.map { |e| (e.gsub('*', '%') + '%').gsub(/%+/, '%')}
    where( terms.map { |term| "LOWER(rooms.name) LIKE ?"}.join(' AND '), *terms.map { |e| [e]} )
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("rooms.created_at #{ direction }")
    when /^name_/
      order("LOWER(rooms.name) #{ direction }")
    when /^size_/
      order("rooms.size #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
  }

  def self.options_for_sorted_by
  [
    [(I18n.t 'sort_options.sort_name_asc'), 'name_asc'],
    [(I18n.t 'sort_options.sort_name_desc'), 'name_desc'],
    [(I18n.t 'sort_options.sort_created_at_desc'), 'created_at_desc'],
    [(I18n.t 'sort_options.sort_created_at_asc'), 'created_at_asc'],
    [(I18n.t 'sort_options.sort_size_asc'), 'size_asc'],
    [(I18n.t 'sort_options.sort_size_desc'), 'size_desc']
  ]
  end
end
