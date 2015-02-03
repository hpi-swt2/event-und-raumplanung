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

  describe "function 'get_name_of_original_event'" do
    it "returns the name of the Event Suggestions original Event preceded by the word Event" do
      event = FactoryGirl.create(:event)
      event_suggestion = FactoryGirl.create(:event_suggestion, :event_id => event.id)
      original_event_name = get_name_of_original_event(event_suggestion)
      expect(original_event_name).to eq('Event ' + event.name)   
    end
  end

  describe "schedule_ends_at_date_not_nil" do
    it "returns now as date if no termination time is set" do
      event = FactoryGirl.create(:weekly_recurring_event)
      expect(schedule_ends_at_date_not_nil(event)).not_to be_nil
    end

    it "returns the termination date if one is set" do
      event = FactoryGirl.create(:daily_recurring_terminating_event)
      expect(schedule_ends_at_date_not_nil(event)).to eq(l(event.schedule_ends_at_date))
    end
  end
end
