class IcalController < AppilcationController
  before_action :authenticate_user!

  Mime::Type.register_alias "text/calendar", :ical
  # GET /ical/event/1
  def show_event
    @event = Event.find(params[:id])
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = Icalendar::Values::Date.new(@event.starts_at)
      e.dtend       = Icalendar::Values::Date.new(@event.ends_at)
      e.summary     = @event.name
      e.description = @event.description
      e.ip_class    = "PRIVATE"
    end

    @cal.publish
    respond_to do |format|
      format.ical { render text: @cal.to_ical }
      format.ics { render text: @cal.to_ical }
      format.html { render plain: @cal.to_ical }
    end
    # render plain: @cal.to_ical
  end

  # GET  /ical/
  def show_my_events
    @events = Event.user(current_user_id)

    @cal = Icalendar::Calendar.new
    @events.each do |event|
      @cal.event do |e|
        e.dtstart     = Icalendar::Values::Date.new(event.starts_at)
        e.dtend       = Icalendar::Values::Date.new(event.ends_at)
        e.summary     = event.name
        e.description = event.description
        e.ip_class    = "PRIVATE"
      end
    end
    @cal.publish
    respond_to do |format|
      format.ical { render text: @cal.to_ical }
      format.ics { render text: @cal.to_ical }
      format.html { render plain: @cal.to_ical }
    end
  end

end
