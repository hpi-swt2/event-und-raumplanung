require_relative '../../app/models/event'
require 'spec_helper'

describe Permission do
  
  before(:all) do
    
  end

  it "has a valid factory" do
    permission = FactoryGirl.create(:permission)
    expect(permission).to be_valid
  end

  it "should give a group a permission" do
    category = "edit_rooms"
    group = FactoryGirl.create(:group)
    expect(group.has_permission(category)).to be false
    group.permit(category)
    expect(group.has_permission(category)).to be true
    group.unpermit(category)
    expect(group.has_permission(category)).to be false
  end

  it "should give a user a permission" do
    category = "edit_rooms"
    user = FactoryGirl.create(:user)
    expect(user.has_permission(category)).to be false
    user.permit(category)
    expect(user.has_permission(category)).to be true
    user.unpermit(category)
    expect(user.has_permission(category)).to be false
  end

  it "should give a users group a permission" do
    category = "edit_rooms"
    user = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group)
    expect(user.has_permission(category)).to be false
    group.permit(category)
    user.groups << group
    expect(user.has_permission(category)).to be true
  end

  it "should give a user a permission on a room" do
    category = "edit_rooms"
    room = FactoryGirl.create(:room)
    user = FactoryGirl.create(:user)
    expect(user.has_permission(category, room)).to be false
    user.permit(category, room)
    expect(user.has_permission(category, room)).to be true
    user.unpermit(category, room)
    expect(user.has_permission(category, room)).to be false
  end

end