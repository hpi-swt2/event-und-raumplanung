module EventsHelper
  def trimDescription(description)
    if description.length > 60
      return description[0, 55] + "[...]"
    end
    return description
  end

  def nl2br(s)
    s.gsub(/\n/, '<br>')
  end

  def concat_rooms(event)
    return event.rooms.map(&:name).to_sentence
  end

  def events_between(start_datetime, end_datetime)
    list = []
    events = Event.all
    events.each do |e|
      e.schedule.occurrences_between(start_datetime - e.duration, end_datetime).each do |time|
        list << EventOccurrence.new({event: e, starts_occurring_at: time, ends_occurring_at: time + e.duration})
      end
    end
    list
  end
end
