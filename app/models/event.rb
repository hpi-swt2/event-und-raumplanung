class Event < ActiveRecord::Base
  include DateTimeAttribute
  include EventModule
  include PaginationModule
  include FilteringModule
  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_settings: { sorted_by: 'created_at_desc',  items_per_page: 10},
    filter_names: [
      :search_query,
      :room_ids,
      :sorted_by,
      :items_per_page,
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

  belongs_to :event

  has_one :event_suggestion, class_name: 'Event', foreign_key: "event_id", dependent: :destroy
  
  has_many :favorites
  has_and_belongs_to_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms

  has_and_belongs_to_many :users

  date_time_attribute :starts_at
  date_time_attribute :ends_at


  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0
  validate :dates_cannot_be_in_the_past,:start_before_end_date

  after_save :set_status_to_pending_and_destroy_suggestion, :if => Proc.new {|event| event.event_suggestion  and event.event_suggestion.status == 'rejected_suggestion' and event.status = 'declined'}
  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.

  scope :items_per_page, lambda { |per|
    #workaround
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
    room_ids = room_ids.select { |room_id| room_id!=''}
    joins(:events_rooms).where("events_rooms.room_id IN (?)",room_ids) if room_ids.size>0
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
  
  scope :open, -> { where.not status: ['approved', 'declined'] }
  scope :approved, -> { where status: 'approved' }
  scope :declined, -> { where status: 'declined' }
  scope :not_declined, -> { where.not status: 'declined' }
  
  def approve
    self.update_attribute(:status, 'approved')
  end
  def decline
    self.update_attribute(:status, 'declined')
  end
  def is_approved
    return self.status == 'approved'
  end

  def set_status_to_pending_and_destroy_suggestion
    self.event_suggestion.destroy
    self.update_columns(:status => 'pending')
  end
end
