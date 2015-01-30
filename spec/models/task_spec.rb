require 'spec_helper'

describe Task do
  it "requires a name" do
  	@task = FactoryGirl.build(:task)
  	@task.name = nil
  	expect(@task.valid?).to be false
  end
  it "requires a deadline" do
  	@task = FactoryGirl.build(:task)
  	@task.deadline = nil
  	expect(@task.valid?).to be false
  end
end