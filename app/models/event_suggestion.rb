class EventSuggestion < ActiveRecord::Base
  include DateTimeAttribute
  has_and_belongs_to_many :rooms
  accepts_nested_attributes_for :rooms 

  date_time_attribute :starts_at
  date_time_attribute :ends_at

  validate :dates_cannot_be_in_the_past,:start_before_end_date

 	
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  

  def dates_cannot_be_in_the_past
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.date_in_the_past')) if starts_at < Date.today
    errors.add(I18n.t('time.ends_at'), I18n.t('errors.messages.date_in_the_past')) if ends_at < Date.today
  end
  def start_before_end_date
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.start_date_not_before_end_date')) if starts_at && starts_at && ends_at < starts_at
  end

end
