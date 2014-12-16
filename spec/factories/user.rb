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
  end

  factory :adminUser, :class => User do |adminUser|
  	adminUser.identity_url "http://example.com/test.admin"
  end


end
