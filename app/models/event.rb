class Event < ActiveRecord::Base
  include DateTimeAttribute

  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :search_query,
      :room_ids,
      :sorted_by,
      :starts_after,
      :ends_before,
      :participants_gte,
      :participants_lte,
      :user
    ]
  )
  self.per_page = 12
  
  has_many :bookings
  has_many :tasks

  has_many :favorites
  has_and_belongs_to_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms

  date_time_attribute :starts_at
  date_time_attribute :ends_at


  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0
  validate :dates_cannot_be_in_the_past,:start_before_end_date



  def dates_cannot_be_in_the_past
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.date_in_the_past')) if starts_at && starts_at < Date.today
    errors.add(I18n.t('time.ends_at'), I18n.t('errors.messages.date_in_the_past')) if ends_at && ends_at < Date.today
  end
  def start_before_end_date
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.start_date_not_before_end_date')) if starts_at && starts_at && ends_at < starts_at
  end

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
    if room_ids.present?
      joins(:events_rooms).where("events_rooms.room_id IN (?)",room_ids.select { |room_id| room_id!=''})
    else
      all
    end
  }
  scope :starts_after, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('starts_at >= ?', date)
  }
  scope :ends_before, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('ends_at <= ?', date)
  }
  scope :participants_gte, lambda { |count|
    where('participant_count >= ?', count)
  }
  scope :participants_lte, lambda { |count|
    where('participant_count <= ?', count)
  }
  scope :user, lambda { |id|
    if id.present?
      where(user_id: id)
    else
      all
    end
  }

  scope :other_to, lambda { |event_id|
    where("id <> ?",event_id) if event_id
  }

  scope :not_approved, lambda {
    where("approved is NULL OR approved = ?", true)
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


  def checkVacancy(rooms) 
    logger.info "checkVacancy"
    logger.info self.starts_at 
    logger.info self.ends_at  
    logger.info rooms 
    colliding_events = []
    unless rooms.nil?
      rooms = rooms.collect{|i| i.to_i}
    end

    events =  Event.other_to(id).not_approved.overlapping(starts_at,ends_at)
    puts events.inspect
    if events.empty?
      return colliding_events
    else
      unless rooms.nil?
        rooms_count = rooms.size
        events.each do | event |
          puts event.rooms.inspect
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
