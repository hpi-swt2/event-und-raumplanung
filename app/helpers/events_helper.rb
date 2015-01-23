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

	def get_name_of_original_event event 
		return 'Event ' + event.event.name
	end

  def schedule_ends_at_time_not_nil(event)
    time = event.schedule_ends_at_time
    if time.nil?
      Time.now.advance(hours: 1)
    else
      time
    end
  end

  def schedule_ends_at_date_not_nil(event)
    date = event.schedule_ends_at_date
    if date.nil?
      Time.now.advance(hours: 1).to_date
    else
      date.to_date
    end
  end
end
