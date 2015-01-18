require 'rails_helper'

describe EventsApprovalHelper, :type => :helper do

	before(:all) do
		@event = FactoryGirl.build(:event, starts_at: '2015-01-08 10:40:00 +0100', ends_at: '2015-01-08 12:34:00 +0100')
	end

	describe "function timeslot_as_string(event)" do
		it "returns the start and end hours" do
			computed_result = timeslot_as_string(@event)
			correct_result = '10:40-12:34'
			expect(computed_result).to eq(correct_result)   
		end
	end

	describe "function timeslot_with_date_as_string(event)" do
		it "returns the day and the start and end hours" do
			computed_result = timeslot_with_date_as_string(@event)
			correct_result = 'Thursday, 08/01/15 10:40-12:34'
			expect(computed_result).to eq(correct_result)   
		end
	end

end