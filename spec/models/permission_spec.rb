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
    expect(group.permissions).to include(permission)
  end

  it "should give a user a permission" do
    permission = FactoryGirl.create(:permission)
    user = FactoryGirl.create(:user)
    user.permissions << permission
    expect(permission.permitted_entity).to eq(user)
    expect(user.permissions).to include(permission)
  end

  it "should give a user a permission on a room" do
    permission = FactoryGirl.create(:permission)
    room = FactoryGirl.create(:room)
    permission.room = room
    user = FactoryGirl.create(:user)
    user.permissions << permission
    expect(user.permissions.collect { |p| p.room }).to include(room)
  end

end