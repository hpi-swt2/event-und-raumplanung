require 'spec_helper'
include RequestHelpers

RSpec.feature "Task" do
    background do
	    # not needed anymore..
    end

    before(:each) do
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_admin }

   
    #
    #
    scenario "create minimal Task without rights", js: true do
  		page.visit "/tasks"
		page.should have_text("Aufgaben")
		page.click_link("Aufgabe erstellen", :match => :first)
		page.should have_text("Aufgabe hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		page.click_button "Absenden"
		page.should have_content("You are not authorized to access this page")
    end

    #
    #
    scenario "create minimal Task with rights", js: true do
   		page.visit "/events"
		have_text("Eventübersicht")
  		page.first(:link, "Editieren").click
		have_text("details for an event of admins")
		save_and_open_page
		page.first(:link, "Aufgabe erstellen").click
		page.click_link("Aufgabe erstellen", :match => :first)
		page.should have_text("Aufgabe hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		page.click_button "Absenden"
		page.should have_content("You are not authorized to access this page")
    end

    #
    #
    scenario "create a task for an Event witout mandatory fields", js: true do
  		page.visit "/events"
		have_text("Eventübersicht")
   		page.first(:link, "Editieren").click
		have_text("details for an event of admins")
		page.first(:link, "Aufgabe erstellen").click
		have_text("Aufgabe hinzufügen")
		page.click_button "Absenden"
		page.should have_content("muss ausgefüllt werden.")
    end

    #
    #
    scenario "create Task with deadline and assignment", js: true do
  		page.visit "/events"
		have_text("Eventübersicht")
 		page.first(:link, "Editieren").click
		have_text("details for an event of admins")
		page.first(:link, "Aufgabe erstellen").click
		have_text("Aufgabe hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		page.fill_in "datetimepicker", with: Date.tomorrow
		page.fill_in "task_identify_display", with: "test_admin"
		page.click_button "Absenden"
		save_and_open_page
		page.should have_content("Aufgabe wurde erfolgreich erstellt.")
		have_text("test_admin")
    end

    #
    #
    scenario "create Task with attachment", js: true do
  		page.visit "/tasks"
		page.should have_text("Task")
		#page.click_button "Hinzufügen"
		page.click_link("Aufgabe erstellen", :match => :first)
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben mit Attachment."
		#expect(page).to have_select("drop_down_id", options: [item1.name, item2.name])

		#Attachment doesnt provide any IDs..
		page.fill_in "attachment_title", with: "Picture"
		page.fill_in "attachment_url", with: "http://zlomenymec.pise.cz/img/264331.jpg"		
		#page.click_link("Anhang hinzufügen", :match => :first)
		#page.find('input[value="Anhang hinzufügen"]').click
		page.click_button "Anhang hinzufügen"
		page.click_button "Löschen" #would delete Anhang
		page.click_button "Absenden"
		save_and_open_page
		page.should have_content("Aufgabe wurde erfolgreich aktualisiert.")
    end

end
