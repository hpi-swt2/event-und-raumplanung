require 'rails_helper'

describe EventsHelper, :type => :helper do
  describe "function 'get_name_of_original_event'" do
    it "returns the name of the Event Suggestions original Event preceded by the word Event" do
      event = FactoryGirl.create(:event)
      event_suggestion = FactoryGirl.create(:event_suggestion)
      original_event_name = get_name_of_original_event(event_suggestion)
    	expect(original_event_name).to eq('Event ' + event.name)   
    end
  end
end