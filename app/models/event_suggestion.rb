class EventSuggestion < ActiveRecord::Base
  include DateTimeAttribute
  include EventModule
  include FilteringModule

  has_and_belongs_to_many :rooms
  belongs_to :event
  accepts_nested_attributes_for :rooms 

  date_time_attribute :starts_at
  date_time_attribute :ends_at

  validate :dates_cannot_be_in_the_past,:start_before_end_date
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  filterrific(
    default_settings: { sorted_by: 'created_at_desc',  items_per_page: 10},
    filter_names: [
      :search_query,
      :room_ids,
      :sorted_by,
      :items_per_page,
      :starts_after,
      :ends_before,
      :user
    ]
  )
  
    scope :items_per_page, lambda { |per|
    #workaround
  }
    scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("event_suggestions.created_at #{ direction }")
    when /^starts_at_/
      order("event_suggestions.starts_at #{ direction }")
    when /^ends_at_/
      order("event_suggestions.ends_at #{ direction }")
    when /^status_/
      order("LOWER(event_suggestions.status) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

   scope :room_ids, lambda { |room_ids|
    room_ids = room_ids.select { |room_id| room_id!=''}
    joins(:events_rooms).where("event_suggestions_rooms.room_id IN (?)",room_ids) if room_ids.size>0
  }

  scope :starts_after, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('starts_at >= ?', date)
  }

  scope :ends_before, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('ends_at <= ?', date)
  }

    scope :user, lambda { |id|
    if id.present?
      where(user_id: id)
    else
      all
    end
  }

  def self.options_for_sorted_by
  [
    [(I18n.t 'sort_options.sort_created_at_desc'), 'created_at_desc'],
    [(I18n.t 'sort_options.sort_created_at_asc'), 'created_at_asc'],
    [(I18n.t 'sort_options.sort_starts_at_desc'), 'starts_at_desc'],
    [(I18n.t 'sort_options.sort_starts_at_asc'), 'starts_at_asc'],
    [(I18n.t 'sort_options.sort_ends_at_desc'), 'ends_at_desc'],
    [(I18n.t 'sort_options.sort_ends_at_asc'), 'ends_at_asc'],
    [(I18n.t 'sort_options.sort_status'), 'status_asc']
  ]
  end
end
