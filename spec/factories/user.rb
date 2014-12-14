FactoryGirl.define do

  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
    sequence(:username) { |n| "test.user#{n}" }
    sequence(:email) { |n| "test.user#{n}@example.com" }

  end

  factory :adminUser, :class => User do |adminUser|
  	adminUser.identity_url "test_admin"
    adminUser.email "test_admin@example.com"
    adminUser.encrypted_password "test_admin"
  end

  factory :hpiUser, :class => User do |hpiUser|
    hpiUser.identity_url "hpi_user"
    hpiUser.username "HPI User"
    hpiUser.email "hpi_user@student.hpi.de"
  end
end
