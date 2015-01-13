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

  # we are aware of the aweful performance :), refactore it, if relevant
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

  # we are aware of the aweful performance :), refactore it, if relevant
  def upcoming_events(limit=5)
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
end
