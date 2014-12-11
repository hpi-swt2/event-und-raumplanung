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
		have_text("Eventübersicht")
  		page.click_link "Neu"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "event_participant_count", with: "5"
		page.fill_in "selectpicker", with: "H-E.1"
		page.fill_in "event_starts_at_date", with: Date.tomorrow
		page.fill_in "event_ends_at_date", with: Date.tomorrow
		#page.fill_in "event_starts_at_date", with: "2020-12-09"
		#page.fill_in "event_ends_at_date", with: "2020-12-09"
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_date", with: "16:30"
		page.click_button "Event erstellen"
		page.should have_content("Event wurde erfolgreich erstellt")
    end

    scenario "delete an existing Event" do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Weihnachtsfeier"
		have_text("Details zur Weihnachtsfeier 2015")
		page.first(:link, "Löschen").click

		# currently JS support is missing. should change Capybara::RackTest

		#page.click_button "OK"
		#expect(page.driver.alert_messages.last).to eq "Sind sie sicher?"
		#page.evaluate_script('window.confirm = function() { return true; }')
		#page.accept_alert 'Sind sie sicher?' do
		#	click_button('OK')
		#end
		#page.driver.browser.accept_js_confirms
		#page.driver.browser.switch_to.alert.accept
		#dialog.text.should = "Sind sie sicher?"
		
		page.should have_content("Sind sie sicher?")			
		#page.should have_content("Event wurde erfolgreich gelöscht.")
    end
end
