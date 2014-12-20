class Event < ActiveRecord::Base
  include DateTimeAttribute
  include EventModule
  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :search_query,
      :own,
      :room_ids,
      :sorted_by
    ]
  )
  self.per_page = 12
  has_many :bookings
  has_many :tasks
  has_and_belongs_to_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms

  date_time_attribute :starts_at
  date_time_attribute :ends_at


  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0
  validate :dates_cannot_be_in_the_past,:start_before_end_date



  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
  scope :search_query, lambda { |query|
    terms = query.downcase.split(/\s+/)
    terms = terms.map { |e| (e.gsub('*', '%') + '%').gsub(/%+/, '%')}
    where( terms.map { |term| "LOWER(events.name) LIKE ?"}.join(' AND '), *terms.map { |e| [e]} )
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("events.created_at #{ direction }")
    when /^starts_at_/
      order("events.starts_at #{ direction }")
    when /^ends_at_/
      order("events.ends_at #{ direction }")
    when /^name_/
      order("LOWER(events.name) #{ direction }")
    when /^status_/
      order("LOWER(events.status) #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
  }
  scope :room_ids, lambda { |room_ids|
    joins(:events_rooms).where("events_rooms.room_id IN (?)",room_ids.select { |room_id| room_id!=''})
  }
  scope :own, lambda { |user_id|
    where("user_id = ?",user_id) if user_id
  }

  scope :other_to, lambda { |event_id|
    where("id <> ?",event_id) if event_id
  }

  scope :not_approved, lambda {
    where("approved is NULL OR approved = TRUE")
  }

  scope :overlapping, lambda { |start, ende|
    where("     (:start BETWEEN starts_at AND ends_at)
            OR  (:ende BETWEEN starts_at AND ends_at)
            OR  (:start < starts_at AND :ende > ends_at)", {start:start, ende: ende})
  }
  def self.options_for_sorted_by
  [
    [(I18n.t 'sort_options.sort_name'), 'name_asc'],
    [(I18n.t 'sort_options.sort_created_at_desc'), 'created_at_desc'],
    [(I18n.t 'sort_options.sort_created_at_asc'), 'created_at_asc'],
    [(I18n.t 'sort_options.sort_starts_at_desc'), 'starts_at_desc'],
    [(I18n.t 'sort_options.sort_starts_at_asc'), 'starts_at_asc'],
    [(I18n.t 'sort_options.sort_ends_at_desc'), 'ends_at_desc'],
    [(I18n.t 'sort_options.sort_ends_at_asc'), 'ends_at_asc'],
    [(I18n.t 'sort_options.sort_status'), 'status_asc']
  ]
  end

  def check_vacancy(rooms)
    colliding_events = []
    unless rooms.nil?
      rooms = rooms.collect{|i| i.to_i}
    end

    events =  Event.other_to(id).not_approved.overlapping(starts_at,ends_at)
    if events.empty?
      return colliding_events
    else
      unless rooms.nil?
        rooms_count = rooms.size
        events.each do | event |
          if (rooms - event.rooms.pluck(:id)).size < rooms_count
             colliding_events.push(event)
          end
        end
      end
    end
    return colliding_events
  end

  scope :open, -> { where.not status: ['approved', 'declined'] }
  scope :approved, -> { where status: 'approved' }
  scope :declined, -> { where status: 'declined' }

end
