require 'spec_helper'
include RequestHelpers

RSpec.feature "Task" do
    background do
	    #@user = FactoryGirl.create :user, email: 'jack@daniels.com'
    end

    before(:each) do
	   # page.set_rack_session(:user_id => @user.id) 
	    load Rails.root + "spec/support/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_admin }

    # Missing JS support...
<<-DOC
    scenario "create minimal Task", js: true do
  		page.visit "/tasks"
		page.should have_text("Aufgaben")
		#page.click_button "Hinzufügen"
		page.click_link("Aufgabe erstellen", :match => :first)
		page.should have_text("Aufgabe hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		page.click_button "Absenden"
		page.should have_content("Aufgabe wurde erfolgreich erstellt.")
    end

    scenario "create a task for an Event witout mandatory fields", :create_task_for_Event_witout_mandatory_fields => true do
  		page.visit "/events"
		have_text("Eventübersicht")
   		page.click_link "AdminEvent"
		have_text("details for an event of admins")
		page.first(:link, "Aufgabe erstellen").click
		have_text("Aufgabe hinzufügen")
		page.click_button "Absenden"
		save_and_open_page
		page.should have_content("muss ausgefüllt werden.")
    end

    scenario "create Task with deadline and assignment", :create_task_with_deadline_assignment => true do
  		page.visit "/events"
		have_text("Eventübersicht")
 		page.click_link "AdminEvent"
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

    scenario "create Task with attachment", :create_task_with_attachment => true do
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
DOC
end
