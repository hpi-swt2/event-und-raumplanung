class IcalController < ApplicationController
  before_action :authenticate_user!

  #Mime::Type.register_alias "text/calendar", :ical

  # GET /ical
  def get
    @owned_events     = Event.where(user_id: current_user.id)
    @favorites        = Event.joins(:favorites).where('events.user_id != ? AND favorites.user_id = ? AND favorites.is_favorite = true', current_user.id, current_user.id)
    @events_with_task = Event.joins(:tasks).where("tasks.identity_type = 'User' AND tasks.identity_id = ?" , current_user.id)

    @event_ids  = @owned_events.collect{ |event| event.id }.uniq
    @event_ids += @favorites.collect{ |event| event.id }.uniq
    @event_ids += @events_with_task.collect{ |event| event.id }.uniq

    @events = Event.find(@event_ids)

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
        e.dtstart     = Icalendar::Values::DateTime.new(event.starts_at)
        e.dtend       = Icalendar::Values::DateTime.new(event.ends_at)
        e.organizer   = "mailto:" + User.find(event.user_id).email
        e.summary     = event.name
        e.description = event.description
        e.location    = event.rooms.map(&:name).to_sentence
        e.ip_class    = "PRIVATE"
        if event.occurence_rule
          rule = event.occurence_rule.to_ical
          if rule.include? "UNTIL"
            e.rrule        = rule
          else
            e.rrule        = event.occurence_rule.until(Date.today + 365).to_ical
          end
        end
      end
    end

    def render_ical cal
      respond_to do |format|
        format.ical { render text: @cal.to_ical }
        format.ics  { render text: @cal.to_ical }
        format.html { render plain: @cal.to_ical }
      end
    end

end
