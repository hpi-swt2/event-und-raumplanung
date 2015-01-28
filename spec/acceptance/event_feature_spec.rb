require 'spec_helper'
include RequestHelpers
#include Warden::Test::Helpers
#Warden.test_mode!

RSpec.feature "Event" do
    background do
	 #   @user = FactoryGirl.create :user, email: 'jack.daniels@hpi.uni-potsdam.de'
	@admin = FactoryGirl.create(:adminUser)
    end


    before(:each) do
	   # page.set_rack_session(:user_id => @admin.id) 
	    page.set_rack_session(:user_id => 1) 
	    #page.set_rack_session(:user_id => @user.id) 
		#page.set_rack_session(:user_id => @user.id) 
	 #   admin = FactoryGirl.create(:adminUser)
	#    login_as(admin , :scope => :user)
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_user }

    scenario "create a new Event without mandatory field", :create_new_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Neu"
		page.fill_in "event_name", with: "Acceptance Tests schreiben"
		page.fill_in "event_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "event_participant_count", with: "5"
		page.fill_in "event_starts_at_date", with: Date.tomorrow
		page.fill_in "event_ends_at_date", with: Date.tomorrow
		#page.fill_in "event_starts_at_date", with: "2020-12-09"
		#page.fill_in "event_ends_at_date", with: "2020-12-09"
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_time", with: "16:30"
		page.click_button "Event erstellen"
		page.should have_content("1 Fehler")
    end

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
		#page.fill_in "event_starts_at_date", with: "2020-12-09"
		#page.fill_in "event_ends_at_date", with: "2020-12-09"
		page.fill_in "event_starts_at_time", with: "12:30"
		page.fill_in "event_ends_at_time", with: "16:30"
		page.click_button "Event erstellen"
		page.should have_content("Event wurde erfolgreich erstellt")
    end

    scenario "delete an existing Event", :delete_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Klubtreffen"
		have_text("Klubtreffen des PR-Klubs")
		#save_and_open_page
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

    scenario "comment on an Event", :comment_on_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
 		page.click_link "Klubtreffen"
		have_text("Klubtreffen des PR-Klubs")
		#save_and_open_page
		page.fill_in "commentContent", with: "Going to modify this Event"
		page.first(:link, "Kommentieren").click
		have_text("Kommentar wurde erfolgreich erstellt.")
    end

    scenario "create a task for an Event", :create_task_for_event => true do
  		page.visit "/events"
		have_text("Eventübersicht")
  		page.click_link "Klubtreffen"
		have_text("Klubtreffen des PR-Klubs")
		page.first(:link, "Aufgabe erstellen").click
		have_text("Aufgabe hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		page.click_button "Absenden"
		page.should have_content("Aufgabe wurde erfolgreich erstellt.")
    end

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
