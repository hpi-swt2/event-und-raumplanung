require 'spec_helper'

describe Task do
  let(:assigned_user) { create :user }
  let(:creator_user) { create :user }
  let(:event) { create :event, user_id: creator_user.id }
  let(:task) { create :mailing_task, event_id: event.id, identity: assigned_user, creator: creator_user }

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "requires a name" do
  	@task = FactoryGirl.build(:task)
  	@task.name = nil
  	expect(@task.valid?).to be false
  end

  it "sends an email when the status changed to accepted" do
  	task.status = 'accepted'
  	test = task.save
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

  it "sends an email when the status changed to declined" do
  	task.status = 'declined'
  	task.save
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

  it "requires a deadline" do
  	@task = FactoryGirl.build(:task)
  	@task.deadline = nil
  	expect(@task.valid?).to be false
  end
end