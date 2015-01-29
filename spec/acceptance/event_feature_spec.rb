require 'spec_helper'
include RequestHelpers

RSpec.feature "Event" do
    background do
	 #   not needed anymore..
    end


    before(:each) do
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_admin }
    
    #
    #
    scenario "create a new Event without mandatory field", :create_new_event => true do
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

<<-DOC #fails due to untestable selectpicker.. :(
    #
    #
    scenario "create a new Event", :create_new_event => true do
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
DOC
   
    #
    #
    scenario "delete an existing Event", :delete_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Klubtreffen"
		have_text("Klubtreffen des PR-Klubs")
		page.first(:link, "Löschen").click		
		page.should have_content("Event wurde erfolgreich gelöscht.")
    end

    #
    #
    scenario "comment on an Event", js: true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "AdminEvent"
		have_text("details for an event of admins")
		page.fill_in "commentContent", with: "Going to modify this Event"
		page.click_on("Kommentieren", :match => :first)
		have_text("Kommentar wurde erfolgreich erstellt.")
    end

    #
    #
    scenario "edit an already approved Event", :edit_already_approved_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
 		page.click_link "Klubtreffen"
		have_text("Klubtreffen des PR-Klubs")
		page.first(:link, "Editieren").click
		have_text("Event editieren")
		page.fill_in "event_ends_at_time", with: "16:31"
		page.click_button "Event aktualisieren"
		page.should have_content("Event wurde erfolgreich aktualisiert.")
    end

end
