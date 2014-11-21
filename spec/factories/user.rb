FactoryGirl.define do
  factory :user do
    sequence(:identity_url) { |n| "http://example.com/test.user#{n}" }
    email "test.user@exampel.com"
  end
end