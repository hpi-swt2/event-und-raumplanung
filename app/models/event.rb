class Event < ActiveRecord::Base
  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :sorted_by,
      :search_query,
      :own,
      :sorted_by
    ]
  )

  has_many :bookings
  has_many :tasks
  has_many :rooms, dependent: :nullify

  validates :name, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true
  validates :end_time, presence: true

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0
  validate :dates_cannot_be_in_the_past,:start_before_end_date

accepts_nested_attributes_for :rooms 
   
   def dates_cannot_be_in_the_past

      errors.add(:start_date, "can't be in the past") if start_date && start_date < Date.today
      errors.add(:end_date, "can't be in the past") if end_date && end_date < Date.today
    end
   def start_before_end_date
      errors.add(:start_date, "start has to be before the end") if start_date && end_date && end_date < start_date
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
    when /^name_/
     # Simple sort on the name colums
      order("LOWER(events.name) #{ direction }")
    when /^status_/
      order("LOWER(events.status) #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
  }
  scope :own, lambda { |user_id|
    where("user_id = ?",user_id)
  }

  def self.options_for_sorted_by
  [
    ['Name (a-z)', 'name_asc'],
    ['Erstellungsdatum (newest first)', 'created_at_desc'],
    ['Erstellungsdatum (oldest first)', 'created_at_asc'],
    ['Status', 'status_asc']
  ]
  end


end
