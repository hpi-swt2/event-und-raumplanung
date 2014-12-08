FactoryGirl.define do

  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
  end

  factory :admin_user, class: User  do
  	identity_url "http://example.com/test.admin"
  end

end