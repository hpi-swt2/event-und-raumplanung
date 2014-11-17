require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  setup do
  	user = users(:one)
  	task = tasks(:one)
  	@email = UserMailer.user_assigned_to_task_email(user, task).deliver
  end

  test "user assigned to task notification is sent" do
    assert_not ActionMailer::Base.deliveries.empty?
  end

  test "email address of sender is set" do
    assert_equal ['no-reply@example.com'], @email.from
  end

  test "email address of recipient is set" do
  	assert_equal ['user@example.com'], @email.to
  end

  test "email subject is set" do
  	assert_equal 'MyString was assigned to you', @email.subject
  end
end
