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
    permission = FactoryGirl.create(:permission)
    group = FactoryGirl.create(:group)
    group.permissions << permission
    expect(permission.permitted_entity).to eq(group)
    expect(group.has_permission(permission.category)).to be true
  end

  it "should give a user a permission" do
    permission = FactoryGirl.create(:permission)
    user = FactoryGirl.create(:user)
    expect(user.has_permission(permission.category)).to be false
    user.permissions << permission
    expect(permission.permitted_entity).to eq(user)
    expect(user.has_permission(permission.category)).to be true
  end

  it "should give a users group a permission" do
    permission = FactoryGirl.create(:permission)
    user = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group)
    expect(user.has_permission(permission.category)).to be false
    group.permissions << permission
    user.groups << group
    expect(user.has_permission(permission.category)).to be true
  end

  it "should give a user a permission on a room" do
    permission = FactoryGirl.create(:permission)
    room = FactoryGirl.create(:room)
    permission.room = room
    user = FactoryGirl.create(:user)
    expect(user.has_permission(permission.category, room)).to be false
    user.permissions << permission
    expect(user.has_permission(permission.category, room)).to be true
  end

end