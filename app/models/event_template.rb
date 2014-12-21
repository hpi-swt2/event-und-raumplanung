class EventTemplate < ActiveRecord::Base
  include FilteringModule
  # This directive enables Filterrific for the Student class.
  # We define a default sorting by most recent sign up, and then
  # we make a number of filters available through Filterrific.
  filterrific(
    default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :search_query,
      :sorted_by
    ]
  )
  self.per_page = 12
  has_and_belongs_to_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms 


  validates :name, presence: true

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0

 
  
  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.

  scope :only_from, lambda { |user_id|
    where("user_id = ?",user_id)
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("event_templates.created_at #{ direction }")
    when /^name_/
      order("LOWER(event_templates.name) #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
  }
  def self.options_for_sorted_by
  [
    [(I18n.t 'sort_options.sort_name'), 'name_asc'],
    [(I18n.t 'sort_options.sort_created_at_desc'), 'created_at_desc'],
    [(I18n.t 'sort_options.sort_created_at_asc'), 'created_at_asc'],
  ]
  end


end
