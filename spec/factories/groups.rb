# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "AGroup#{n}" }
     factory :group_with_room do |g|
		g.id 55
  	end
  end
end
