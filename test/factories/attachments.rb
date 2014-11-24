# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    title "MyString"
    url "MyString"
    task nil
  end
  factory :admin do
  	identity_url "http://example.com/test.admin"
  end
  
end
