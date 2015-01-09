require 'spec_helper'
include RequestHelpers

RSpec.feature "Task" do
    background do
	    @user = FactoryGirl.create :user, email: 'jack@daniels.com'
    end

    before(:each) do
	    page.set_rack_session(:user_id => @user.id) 
	    load Rails.root + "db/seeds.rb" 
    end

    let!(:authed_user) { create_logged_in_user }

    # current there is an error when no attachment is provided
    #"Konnte Task nicht speichern: 3 Fehler. 
    #  - Attachments title muss ausgefüllt werden 
    #  - Attachments url muss ausgefüllt werden 
    #  - Attachments url ist nicht gültig"


    scenario "create subtle Task" do
  		page.visit "/tasks"
		page.should have_text("Task")
		#page.click_button "Hinzufügen"
		page.click_link("Neu", :match => :first)
		page.should have_text("Task hinzufügen")
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		#expect(page).to have_select("drop_down_id", options: [item1.name, item2.name])
	
		page.click_button "Task erstellen"
		page.should have_content("Task wurde erfolgreich erstellt.")
    end

    scenario "create Task  with attachment" do
  		page.visit "/tasks"
		page.should have_text("Task")
		#page.click_button "Hinzufügen"
		page.click_link("Neu", :match => :first)
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben mit Attachment."
		#expect(page).to have_select("drop_down_id", options: [item1.name, item2.name])
		
		#Attachment doesnt provide any IDs..
		page.fill_in "attachment_title", with: "Picture"
		page.fill_in "attachment_url", with: "http://zlomenymec.pise.cz/img/264331.jpg"		
		#page.click_link("Anhang hinzufügen", :match => :first)
		#page.find('input[value="Anhang hinzufügen"]').click
		page.click_button "Anhang hinzufügen"
		page.click_button "Delete" #would delete Anhang
		page.click_button "Task erstellen"
		page.should have_content("Task wurde erfolgreich erstellt.")
    end

end