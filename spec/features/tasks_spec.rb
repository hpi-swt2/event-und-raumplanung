require 'rails_helper'

feature "Tasks", :type => :feature do
  describe 'task list' do
  	let(:event) { FactoryGirl.create :event }
  	let(:task) { FactoryGirl.create :task, event_id: event.id }
  	describe 'mark task as done', js: true do
  		it 'should set task to done' do
  			visit tasks_path
			click_on ".task-done-checkbox"
			expect(true).to eql true 
  		end
  	end
  end
end
