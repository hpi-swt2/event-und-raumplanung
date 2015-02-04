require 'event_module'
require 'pagination_module'
require 'filtering_module'

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

  has_many :tasks
  has_many :equipment_requests
  has_many :activities
  belongs_to :event
  has_one :event_suggestion, class_name: 'Event', foreign_key: "event_id", dependent: :destroy

  has_many :favorites
  has_and_belongs_to_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms

  date_time_attribute :starts_at
  date_time_attribute :ends_at

  validates_presence_of :name, :starts_at, :ends_at, :rooms

  validates_numericality_of :participant_count, only_integer: true, greater_than_or_equal_to: 0
  validate :dates_cannot_be_in_the_past, :if => lambda{ new_record? }
  validate :start_before_end_date

  validate :validate_schedule

  after_save :set_status_to_pending_and_destroy_suggestion, :if => Proc.new {|event| event.event_suggestion and event.event_suggestion.status == 'rejected_suggestion' and event.status = 'declined'}
  after_create :check_group
  # after_save do
  #   if self.event_suggestion  and self.event_suggestion.status == 'rejected_suggestion' and self.status = 'declined'
  #     set_status_to_pending_and_destroy_suggestion
  #   end
  #   check_group
  # end

  def validate_schedule
    self.schedule = IceCube::Schedule.new(self.starts_at, end_time: self.ends_at) if read_attribute(:schedule).nil?
  end

  def schedule=(new_schedule)
    write_attribute(:schedule, new_schedule.to_yaml)
  end

  def schedule
    IceCube::Schedule.from_yaml(read_attribute(:schedule)) if read_attribute(:schedule)
  end

  def schedule_from_rule(dirty_rule, termination_date=nil)
    validate_schedule
    schedule = self.schedule
    schedule.start_time = self.starts_at
    schedule.end_time = self.ends_at
    if schedule.exception_times
      schedule.exception_times.each do |exception_time|
        schedule.remove_exception_time(exception_time)
      end
    end
    schedule.remove_recurrence_rule(schedule.recurrence_rules.first) unless schedule.recurrence_rules.empty?
    unless dirty_rule.nil? || dirty_rule == "null"
      rule = RecurringSelect.dirty_hash_to_rule(dirty_rule)
      date = Date.parse(termination_date) if termination_date.present?
      rule.until(date)
      schedule.add_recurrence_rule rule
    end
    self.schedule = schedule
  end

  def occurence_rule
    schedule = self.schedule
    schedule.recurrence_rules.first if schedule && !schedule.recurrence_rules.empty?
  end

  def delete_occurrence(time)
    schedule = self.schedule
    schedule.add_exception_time(time)
    self.update!(schedule: schedule)
  end

  def single_occurrence_event?
    occurence_rule.nil?
  end

  def schedule_ends_at_date
    schedule = self.schedule
    if schedule && !schedule.recurrence_rules.empty? && schedule.terminating?
      return schedule.recurrence_rules.first.until_time.to_date
    end
  end

  def duration
    (self.ends_at - self.starts_at).seconds
  end

  def involved_users
    involved = Array.new
    involved << User.find(self.user_id)
    involved += get_involved_entities
    involved += get_involved_group_leaders
    return involved
  end

  def get_involved_entities
    involved = Array.new
    self.tasks.each do | task |
      if task.identity_type == 'User'
        involved << User.find(task.identity_id)
      elsif task.identity_type == 'Group'
        Group.find(task.identity_id).users.each {|user| involved << user}
      end
    end
    return involved
  end

  def get_involved_group_leaders
    involved = Array.new
    self.rooms.each do |room|
      if room.group
        room.group.leaders.each do |leader|
          involved << leader
        end
      end
    end
    return involved
  end

  def in_week(week, year)
    weekBegin = Date.commercial(year, week, 1)
    weekEnd = Date.commercial(year, week+1, 1)
    return (self.ends_at >= weekBegin && self.starts_at <= weekEnd)
  end

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
  scope :approved, lambda {
    where("status = 'approved'")
  }

  scope :starts_after, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('starts_at >= ?', date)
  }

  scope :ends_before, lambda { |ref_date|
    date = DateTime.strptime(ref_date, I18n.t('datetimepicker.format'))
    where('ends_at <= ?', date)
  }

  scope :week, lambda { |week, year|
    weekBegin = Date.commercial(year, week, 1)
    weekEnd = Date.commercial(year, week+1, 1)
    puts weekBegin
    puts weekEnd
    where('ends_at >= ? AND starts_at <= ?', weekBegin, weekEnd)
  }

  scope :participants_gte, lambda { |count|
    where('participant_count >= ?', count)
  }

  scope :participants_lte, lambda { |count|
    where('participant_count <= ?', count)
  }

  scope :user, lambda { |id|
    where(user_id: id) if id.present?
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

  def pretty_schedule
    if self.occurence_rule.nil?
      I18n.t 'events.show.schedule_not_recurring'
    else
      self.occurence_rule.to_s
    end
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

  def exist_colliding_events
    #event_count = Event.where.not(:id => self.id).where('(starts_at BETWEEN ? AND ?) OR (ends_at BETWEEN ? AND ?)',self.starts_at, self.ends_at, self.starts_at, self.ends_at).count
    #return (event_count > 0)
  end

  # we are aware of the aweful performance :), refactore it, if relevant
  def self.events_between(start_datetime, end_datetime)
    list = []
    events = Event.all
    events.each do |e|
      e.schedule.occurrences_between(start_datetime - e.duration, end_datetime).each do |time|
        list << EventOccurrence.new({event: e, starts_occurring_at: time, ends_occurring_at: time + e.duration})
      end
    end
    list
  end

  # we are aware of the aweful performance :), refactore it, if relevant
  def self.upcoming_events(limit=5)
    list = []
    events = Event.all
    events.each do |e|
      e.schedule.next_occurrences(limit, Time.now).each do |time|
        list << EventOccurrence.new({event: e, starts_occurring_at: time, ends_occurring_at: time + e.duration})
      end
    end
    list.sort_by! { |occurrence| occurrence.starts_occurring_at }
    list[0 .. limit-1]
  end

  def set_status_to_pending_and_destroy_suggestion
    self.event_suggestion.destroy
    self.update_columns(:status => 'pending')
  end

  def check_group
    only_group_rooms = true
    unless self.rooms.empty?
      self.rooms.each do |room|
        if not room.group_id or not User.find(self.user_id).is_member_of_group(room.group_id)
          only_group_rooms = false
        end
      end
      if only_group_rooms
        self.update_columns(:status => 'approved')
      end
    end
  end
end
