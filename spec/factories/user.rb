FactoryGirl.define do

  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
    email "test.user@exampel.com"
  end

  factory :adminUser, :class => User do |adminUser|
  	adminUser.identity_url "http://example.com/test.admin"
  end
end
