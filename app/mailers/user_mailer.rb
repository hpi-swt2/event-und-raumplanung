class UserMailer < ActionMailer::Base
  default from: "no-reply@example.com"

  def user_assigned_to_task_email(user, task) 
  	@user = user
  	@task = task
  	mail(to: @user.email, subject: @task.name + ' was assigned to you')
  end
end
