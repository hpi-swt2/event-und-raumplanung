require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "user assigned to task notification is sent" do
  	user = users(:one)
  	task = tasks(:one)
  	email = UserMailer.user_assigned_to_task_email(user, task).deliver
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@example.com'], email.from
    assert_equal ['user@example.com'], email.to
    assert_equal 'MyString was assigned to you', email.subject
  end
end
