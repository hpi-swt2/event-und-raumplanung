FactoryGirl.define do
  factory :room_property do |f|
    f.name "Property"
  end
  factory :room_property1, class: RoomProperty do
                           name 'barrierfree'
                         end
                         factory :room_property2, class: RoomProperty do
                                                  name 'barrierfree2'
                                                end
end
