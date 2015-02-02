require 'rails_helper'

RSpec.describe Group, :type => :model do
  it "has a valid factory" do
    factory = FactoryGirl.build(:valid_group)
    expect(factory).to be_valid
  end
  it "has a invalid factory" do
    factory = FactoryGirl.build(:invalid_group)
    expect(factory).not_to be_valid
  end
  it "has a unique name" do
    factory = FactoryGirl.create(:valid_group)
    expect(factory).to be_valid
    expect(FactoryGirl.build(:valid_group)).not_to be_valid
    factory.destroy()
  end

  it "has many rooms, tasks, memberships and users" do
	
	t = Group.reflect_on_association(:memberships)
	assert(t.macro == :has_many)
	t = Group.reflect_on_association(:users)
	assert(t.macro == :has_many)
  end

  it 'should return groups for a name' do
  	@valid_group = FactoryGirl.create(:valid_group)
   	results = Group.search_name(@valid_group.name)
   	expect(results).to include(@valid_group)
   	results = Group.search_name(@valid_group.name[0])
   	expect(results).to include(@valid_group)
   	results = Group.search_name(@valid_group.name + 'a')
   	expect(results).not_to include(@valid_group)
   	@valid_group.destroy
  end

  it 'should return all groups of a user' do 
  	@user = FactoryGirl.create(:groupMember)
  	@otherGroup = FactoryGirl.create(:valid_group)
  	@groups = Group.get_all_groups_of_current_user(@user.id)
  	assert (@groups.count == 1)
  	@user.destroy
  	@otherGroup.destroy
  end
end
