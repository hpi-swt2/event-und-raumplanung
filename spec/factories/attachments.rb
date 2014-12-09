FactoryGirl.define do
  factory :attachment do
    title 'Title'
    url 'http://example.com'
    association :task_id, factory: :task

    factory :attachment_with_invalid_url do
      url "this://isnot.a/url"
    end
  end
end