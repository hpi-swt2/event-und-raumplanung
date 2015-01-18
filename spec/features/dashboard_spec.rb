feature 'Dashboard' do
	describe 'My tasks partial' do
		let(:user) { create :user }
		let!(:event) { create :event, user_id: user.id }
		let!(:task) { create :assigned_task, event_id: event.id, user_id: user.id }

		before(:each) do
			login_as user, scope: :user
			visit '/'
		end

		scenario 'click on events name redirects to events page' do
			#first(:link, event.name).click
			#current_path.should == event_path(event) 
		end

		scenario 'click on tasks name redirects to tasks page' do
			click_link task.name
			current_path.should == task_path(task)
		end
	end


end