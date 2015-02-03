FactoryGirl.define do
  factory :equipment do |f|
    f.name 'beamer'
    f.category 'Beamer'
    room
  end
  
  factory :correct_equipment, :class => Equipment do |f|
    f.name 'Beamer HD 1'
    f.category 'Beamer'
  end

  factory :incorrect_equipment1, :class => Equipment do |f|
    f.name 'Beamer HD 1'
  end

  factory :incorrect_equipment2, :class => Equipment do |f|
    f.category 'Beamer'
  end

end