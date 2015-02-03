#require '../../app/models/comments'
require 'spec_helper'


describe Comments, :type => :model do

  it "has a valid factory" do
    factory = FactoryGirl.build(:correct_comment)
    expect(factory).to be_valid
  end

  it "should belong to an user" do
    t = Comments.reflect_on_association(:user)
    t.macro.should == :belongs_to
  end

  it "should belong to an event" do
    t = Comments.reflect_on_association(:event)
    t.macro.should == :belongs_to
  end

  it "should create a valid comment" do
    @comment = FactoryGirl.build(:correct_comment)
    expect(@comment.event_id).to eq(1)
    expect(@comment.user_id).to eq(1)
    expect(@comment.content).to eq("Some content")
  end

  it "should be invalid without presence of user_id, event_id and content" do
    @comment = FactoryGirl.build(:incorrect_comment)
    expect(@comment).not_to be_valid

    @comment = FactoryGirl.build(:incorrect_comment2)
    expect(@comment).not_to be_valid

    @comment = FactoryGirl.build(:incorrect_comment3)
    expect(@comment).not_to be_valid
  end
end
