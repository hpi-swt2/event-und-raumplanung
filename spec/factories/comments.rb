FactoryGirl.define do

  factory :correct_comment, :class => Comments do |f|
    f.user_id 1
    f.content "Some content"
    f.event_id 1
  end

  factory :incorrect_comment, :class => Comments do |f|
    f.user_id 1
    f.content "Some content"
  end

  factory :incorrect_comment2, :class => Comments do |f|
    f.event_id 1
    f.content "Some content"
  end

  factory :incorrect_comment3, :class => Comments do |f|
    f.event_id 1
    f.user_id 2
    f.content "Too long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long contentToo long content"
  end
end