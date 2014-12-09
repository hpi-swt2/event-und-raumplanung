require_relative '../../app/models/event'
require 'spec_helper'

describe Event do
  let(:event) { FactoryGirl.create(:event) }

  it "has a valid factory" do
    expect(event).to be_valid
  end

  it "should have the :is_private attribute" do
    event.is_private == true or event.is_private == false
  end

  context "schedule is nil" do
    it "schedule returns nil" do
      expect(event.schedule).to be_nil
    end

    it "occurence rule returns nil" do
      expect(event.occurence_rule).to be_nil
    end

    it "string formatting is valid" do
      expect(event.pretty_schedule).to eq(I18n.t 'events.show.schedule_not_recurring')
    end
  end

  context "schedule is non-recurring" do
    let(:schedule_not_recurring) { IceCube::Schedule.new(now = Time.now) }
    let(:event_with_schedule) { FactoryGirl.create(:event, schedule: schedule_not_recurring.to_yaml) }

    it "schedule is set" do
      expect(event_with_schedule.schedule.to_yaml).to eq(schedule_not_recurring.to_yaml)
    end

    it "occurence rule returns nil" do
      expect(event_with_schedule.occurence_rule).to be_nil
    end

    it "string formatting is valid" do
      expect(event_with_schedule.pretty_schedule).to eq(I18n.t 'events.show.schedule_not_recurring')
    end
  end

  context "schedule is recurring" do
    let(:weekly_recurring_event) { FactoryGirl.create(:weekly_recurring_event) }

    it "and occurence rule is set" do
      expect(weekly_recurring_event.occurence_rule).to eq(IceCube::Rule.daily)
    end

    it "and string formatting is valid" do
      expect(weekly_recurring_event.pretty_schedule).to eq(weekly_recurring_event.schedule.to_s)
    end
  end
end