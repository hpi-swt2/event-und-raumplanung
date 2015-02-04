require 'spec_helper_acceptance'
include RequestHelpers

RSpec.feature "Event" do
    background do
	   #   not needed anymore..
    end

    before(:each) do
	    load  Rails.root + "spec/support/seeds.rb"
    end

    let!(:authed_user) { create_logged_in_admin }

    #
    #
    scenario "create a new Event without mandatory field", acceptance_test: true, :create_new_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Neu"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "event_participant_count", with: "5"
		page.fill_in "event_starts_at_date", with: Date.tomorrow
		page.fill_in "event_ends_at_date", with: Date.tomorrow
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_time", with: "16:30"
		page.click_button "Event erstellen"
		page.should have_content("1 Fehler")
    end

    #
    #
    scenario "delete an existing Event", acceptance_test: true, js: true do
  		page.visit "/events"
		  have_text("Eventübersicht")
  		page.click_link "DeleteMePlease"
		  have_text("details for the Event DeleteMePlease")
		  page.first(:link, "Löschen").click
		#
		# Handling of confirmation popup
		#page.should have_content("Sind Sie sicher")
		#alert = page.driver.browser.switch_to.alert  # the following results in a NoMethodError:undefined method `switch_to' for nil:NilClass
		#page.driver.browser.switch_to.alert.accept
		#popup = @driver.switch_to.alert
		#popup.accept
		#sleep 1
		page.should have_content("Event wurde erfolgreich gelöscht.")
    end

    #
    #
    scenario "comment on an Event", acceptance_test: true, js: true, exclude: true do
  		page.visit "/events"
		have_text("Eventübersicht")
		save_and_open_page
  		page.click_link "AdminEvent"
		have_text("details for an event of admins")
		page.fill_in "commentContent", with: "Going to modify this Event"
		save_and_open_page
		sleep 5 # SQLite3::BusyException: database is locked: DELETE FROM "event_templates_rooms";
		page.click_on("Kommentieren", :match => :first)
		have_text("Kommentar wurde erfolgreich erstellt.")
    end

    #
    #
    scenario "edit an already approved Event", acceptance_test: true, js: true do
  		page.visit "/events"
		  have_text("Eventübersicht")
   		page.click_link "AdminEvent"
  		have_text("details for an event of admins")
  		page.first(:link, "Editieren").click
  		have_text("Event editieren")
  		page.fill_in "event_ends_at_time", with: "16:31"
  		page.click_button "Event aktualisieren"
  		page.should have_content("Event wurde erfolgreich aktualisiert.")
    end

##### fails due to untestable selectpicker.. :( ##############################################
    #
    #
    scenario "create a new Event", acceptance_test: true, :create_new_event => true, exclude: true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Neu"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "event_participant_count", with: "5"
		#page.select "H-E.1", from: "button[filter-option pull-left]"
		#select '1', :from => "selectpicker"
		page.select("H-E.1", :from => "selectpicker")
		page.fill_in "selectpicker", with: "H-E.1"
		page.fill_in "event_starts_at_date", with: Date.tomorrow
		page.fill_in "event_ends_at_date", with: Date.tomorrow
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_time", with: "16:30"
		page.click_button "Event erstellen"
		page.should have_content("Event wurde erfolgreich erstellt")
    end

end
