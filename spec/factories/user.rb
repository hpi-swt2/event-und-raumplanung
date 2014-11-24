FactoryGirl.define do
  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
  end
end