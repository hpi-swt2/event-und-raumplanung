require 'rails_helper'

describe TasksController, type: :controller do
  describe "GET accept" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }

    it 'should change tasks status of assigned task to accepted' do
      expect{get :accept, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("accepted")
    end

    it 'should not change tasks status of unassigned task to accepted' do
      expect{get :accept, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end
  end

  describe "GET decline" do
    let(:event) { FactoryGirl.create(:event) }
    let(:user) { FactoryGirl.create(:user) }
    let(:assigned_task) { FactoryGirl.create :assigned_task, event_id: event.id, user_id: user.id }
    let(:unassigned_task) { FactoryGirl.create :unassigned_task, event_id: event.id }

    it 'should change tasks status of assigned task to declined' do
      expect{get :decline, id: assigned_task.id}.to change{Task.find(assigned_task.id).status}.from("pending").to("declined")
    end

    it 'should not change tasks status of unassigned task to declined' do
      expect{get :decline, id: unassigned_task.id}.to_not change{Task.find(unassigned_task.id).status}
    end
  end
end