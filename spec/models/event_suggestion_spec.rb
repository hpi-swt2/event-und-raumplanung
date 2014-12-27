require 'rails_helper'

RSpec.describe EventSuggestion, :type => :model do
	describe EventSuggestion do
		before(:each) do
    		@request.env["devise.mapping"] = Devise.mappings[:user]
    		sign_in user
  		end
		
		it "has a valid factory" do
    		factory = FactoryGirl.build(:event_suggestion)
    		expect(factory).to be_valid
    	end
  		
  		it "should have the status pending when created" do
  			@event_suggestion = FactoryGirl.build(:event_suggestion)
  			expect(@event_suggestion.status).to eq('pending')
  		end
  	end
end

