# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "AGroup#{n}" }
     factory :group_with_room do |g|
		g.id 55
  	end
  end
  factory :valid_group, :class => Group do |f|
  	f.name 'Test'    
  end
  factory :invalid_group, :class => Group do
    
  end
end
