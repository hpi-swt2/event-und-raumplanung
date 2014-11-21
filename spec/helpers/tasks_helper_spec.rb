require 'rails_helper'

describe TasksHelper, :type => :helper do
  describe "set email" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }

    it 'should return email' do
      expect(get_email(assigned_task.user_id)).to eq(user.email)
    end
  end
end