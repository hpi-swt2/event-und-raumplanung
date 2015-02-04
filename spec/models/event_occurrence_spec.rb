require 'rails_helper'

RSpec.describe EventOccurrence, :type => :model do
  let(:event) {create(:weekly_recurring_event)}
  let(:occurrence) {create(:event_occurrence_object, event_id: event.id)}

  it "creates a valid json" do
    json = JSON.parse(occurrence.to_json)
    expect(json['title']).to be
    expect(json['start']).to be
    expect(json['end']).to be
    expect(json['event_id']).to be
    expect(json['color']).to be
  end
end
