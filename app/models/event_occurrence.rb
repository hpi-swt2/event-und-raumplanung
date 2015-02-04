class EventOccurrence < ActiveRecord::Base
  belongs_to :event

  def to_json
    "{\"title\":\"#{event.name}\", \"start\":\"#{self.starts_occurring_at.to_s}\", \"end\":\"#{self.ends_occurring_at.to_s}\", \"event_id\":\"#{self.event_id}\", \"color\":\"#{event.is_approved ? 'green' : 'red'}\"}"
  end
end
