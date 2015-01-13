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
  let(:daily_recurring_event) { FactoryGirl.create(:daily_recurring_event) }

  describe "events_between" do
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
end
