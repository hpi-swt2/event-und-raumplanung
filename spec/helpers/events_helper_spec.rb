require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the EventsHelper. For example:
#
# describe EventsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe EventsHelper, :type => :helper do

  describe "events_between" do
    let(:daily_recurring_event) { FactoryGirl.create(:daily_recurring_event) }

    context "daily event present" do
      it "finds 7 occurrences in a week for a weekly schedule" do
        occurrences = events_between(daily_recurring_event.starts_at, daily_recurring_event.starts_at + 6.days)
        expect(occurrences.count).to eq(7)
        expect(occurrences.first).to be_instance_of(EventOccurrence)
        expect(occurrences.first.starts_occurring_at).to eq(daily_recurring_event.starts_at)
        occurrences.each do |o|
          expect(o.event).to eq(daily_recurring_event)
        end
        expect(occurrences.second.starts_occurring_at).to eq(daily_recurring_event.starts_at + 1.days)
      end
    end

    context "daily and weekly event present" do      
      it "finds 8 occurrences in a week" do
        weekly_recurring_event = FactoryGirl.create(:weekly_recurring_event)
        occurrences = events_between(daily_recurring_event.starts_at, daily_recurring_event.starts_at + 6.days)
        expect(occurrences.count).to eq(8)
        expect(occurrences.first.event).to eq(weekly_recurring_event)
      end
    end
  end

  describe "upcoming_events" do
    context "daily event present" do
      it "finds the next 5 upcoming event occurrences" do
        upcoming_daily_recurring_event = FactoryGirl.create(:upcoming_daily_recurring_event)
        occurrences = upcoming_events(5)
        expect(occurrences.count).to eq(5)
        occurrences.each do |o|
          expect(o.event).to eq(upcoming_daily_recurring_event)
        end
      end

      it "finds the next 5 upcoming event occurrences from multiple events" do
        upcoming_daily_recurring_event = FactoryGirl.create(:upcoming_daily_recurring_event)
        upcoming_daily_recurring_event2 = FactoryGirl.create(:upcoming_daily_recurring_event2)
        occurrences = upcoming_events(5)
        expect(occurrences.count).to eq(5)
        expect(occurrences.first.event).to eq(upcoming_daily_recurring_event)
        expect(occurrences.second.event).to eq(upcoming_daily_recurring_event2)
        expect(occurrences.third.event).to eq(upcoming_daily_recurring_event)
        expect(occurrences.fourth.event).to eq(upcoming_daily_recurring_event2)
        expect(occurrences.fifth.event).to eq(upcoming_daily_recurring_event)
      end
    end
  end

  describe "function 'get_name_of_original_event'" do
    it "returns the name of the Event Suggestions original Event preceded by the word Event" do
      event = FactoryGirl.create(:event)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id)
      original_event_name = get_name_of_original_event(event_suggestion)
      expect(original_event_name).to eq('Event ' + event.name)   
    end
  end

end
