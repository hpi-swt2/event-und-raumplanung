module EventModule
  def self.included(base)
    base.class_eval do
      scope :other_to, lambda { |event_id|
        where("id <> ?",event_id) if event_id
      }

      scope :not_approved, lambda {
      	where("approved is NULL OR approved = TRUE")
      }

  	  scope :overlapping, lambda { |start, ende|
    	where("     (:start BETWEEN starts_at AND ends_at)
            OR  (:ende BETWEEN starts_at AND ends_at)
            OR  (:start < starts_at AND :ende > ends_at)", {start:start, ende: ende})
  	  }
    end
  end

  def dates_cannot_be_in_the_past
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.date_in_the_past')) if starts_at && starts_at < Date.today
    errors.add(I18n.t('time.ends_at'), I18n.t('errors.messages.date_in_the_past')) if ends_at && ends_at < Date.today
  end
  def start_before_end_date
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.start_date_not_before_end_date')) if starts_at && starts_at && ends_at < starts_at
  end

  def setDefaultTime
    time = Time.new.getlocal
    time -= time.sec
    time += time.min % 15
    self.starts_at = time
    self.ends_at = (time+(60*60))
  end

  def check_vacancy(rooms)
    colliding_events = []
    return colliding_events if rooms.nil?

    rooms = rooms.collect{|i| i.to_i}
    events =  Event.other_to(id).not_approved.overlapping(self.starts_at,self.ends_at)

    return colliding_events if events.empty?

    events.each do | event |
      colliding_events.push(event) if (rooms & event.rooms.pluck(:id)).size > 0
    end
    return colliding_events
  end

end