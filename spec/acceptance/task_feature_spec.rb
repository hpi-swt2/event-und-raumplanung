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

    scenario "create Task" do
  		page.visit "/tasks/new"
		#page.click_button "Hinzufügen"
		page.fill_in "task_name", with: "Acceptance Tests schreiben"
		page.fill_in "task_description", with: "Lasst uns Acceptance Tests schreiben."
		#expect(page).to have_select("drop_down_id", options: [item1.name, item2.name])
		
		#Attachment doesnt provide any IDs..
		<<-DOC
		page.fill_in "attachment_title", with: "Picture"
		page.fill_in "attachment_url", with: "http://zlomenymec.pise.cz/img/264331.jpg"		
		page.click_button "Add Attachment"
		page.should have_content("Picture")
		DOC

		page.click_button "Task erstellen"
		page.should have_content("Task wurde erfolgreich erstellt.")
    end
end
