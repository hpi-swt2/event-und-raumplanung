FactoryGirl.define do
  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
    sequence(:username) { |n| "test.user#{n}" }
    sequence(:email) { |n| "test.user#{n}@example.com" }
  end

  factory :adminUser, :class => User do |adminUser|
  	adminUser.identity_url "test_admin"
  end
end
