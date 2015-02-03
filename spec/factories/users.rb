FactoryGirl.define do

  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }

    factory :groupLeader do
    	after :create do |groupLeader|
    		groupLeader.sign_in_count = 1337
    		groupLeader.groups << FactoryGirl.create(:group)
    		mem = groupLeader.memberships.last
    		mem.isLeader = true
    		mem.save()
    		groupLeader.save
    		groupLeader.reload
    	end
  	end

    factory :groupMember do
      after :create do |member|
        member.sign_in_count = 1337
        member.groups << FactoryGirl.create(:group_with_room)
        member.save
        member.reload
      end
    end

    sequence(:username) { |n| "test.user#{n}" }
    sequence(:email) { |n| "test.user#{n}@example.com" }
  end

  factory :adminUser, :class => User do |adminUser|
  	adminUser.identity_url "test_admin"
    adminUser.email "test_admin@example.com"
    adminUser.encrypted_password "test_admin"
    adminUser.username "test_admin"
  end

  factory :hpiUser, :class => User do |hpiUser|
    hpiUser.identity_url "hpi_user"
    hpiUser.username "HPI User"
    hpiUser.email "hpi_user@student.hpi.de"
  end

  factory :userWithoutEmail, :class => User do |userWithoutEmail|
    userWithoutEmail.username "userwithoutemail"
  end
end
