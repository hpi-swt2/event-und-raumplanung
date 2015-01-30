class IcalController < ApplicationController
  before_action :authenticate_user!

  Mime::Type.register_alias "text/calendar", :ical

  # GET /ical/event/1
  def show_event
    @event = Event.find(params[:id])

    @cal = Icalendar::Calendar.new
    add_event_to_cal @cal, @event
    @cal.publish

    render_ical @cal
  end

  # GET /ical/
  def show_my_events
    @events = Event.user(current_user_id)

    @cal = Icalendar::Calendar.new
    @events.each do |event|
      add_event_to_cal @cal, event
    end
    @cal.publish

    render_ical @cal
  end

  private
    def add_event_to_cal cal, event
      cal.event do |e|
        e.dtstart     = Icalendar::Values::Time.new(event.starts_at)
        e.dtend       = Icalendar::Values::Time.new(event.ends_at)
        e.organizer   = "mailto:" + User.find(event.user_id).email
        e.summary     = event.name
        e.description = event.description
        e.ip_class    = "PRIVATE"
        e.rrule        = event.occurence_rule.to_ical
      end
    end

    def render_ical cal
      respond_to do |format|
        format.ical { render text: @cal.to_ical }
        format.ics { render text: @cal.to_ical }
        format.html { render plain: @cal.to_ical }
      end
    end

end
