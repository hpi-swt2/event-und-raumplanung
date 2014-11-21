# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	identity_url "http://example.com/test.user"
  end
  factory :admin do
  	identity_url "http://example.com/test.admin"
  end
  
end
