feature 'Dashboard' do
	describe 'My tasks partial' do
		let(:user) { create :user }
		let(:event) { create :event }
		let(:task) { create :assigned_task, event_id: event.id, user_id: user.id }

		before(:each) do
			login_as user, scope: :user
			visit '/'
		end

		scenario 'click on events name redirects to events page' do
			click_link event.name
			current_page.should == event_path(event) 
		end

		scenario 'click on tasks name redirects to tasks page' do
			click_link task.name
			current_page.should == task_path(task)
		end
	end


end