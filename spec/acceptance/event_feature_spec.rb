require 'spec_helper'
include RequestHelpers

RSpec.feature "Event" do
    background do
	    @user = FactoryGirl.create :user, email: 'jack@daniels.com'
    end

    before(:each) do
	    page.set_rack_session(:user_id => @user.id) 
	    load Rails.root + "db/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_user }

    scenario "create a new Event" do
  		page.visit "/events"
  		page.click_link "Neu"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "event_participant_count", with: "5"

		#not working yet
		<<-DOC
		page.fill_in "selectpicker", with: "H-E.1"
		page.fill_in "event_starts_at_date", with: Date.tomorrow
		page.fill_in "event_ends_at_date", with: Date.tomorrow
		page.fill_in "event_starts_at_date", with: "2020-12-09"
		page.fill_in "event_ends_at_date", with: "2020-12-09"
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_date", with: "16:30"
		DOC

		page.click_button "Event erstellen"
		page.should have_content("Event wurde erfolgreich erstellt")
    end

end
