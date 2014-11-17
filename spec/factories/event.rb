# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
  	name 'PR Klub Treffen'
  	description 'Wir treffen uns.'
  	participant_count 5
  end
end
