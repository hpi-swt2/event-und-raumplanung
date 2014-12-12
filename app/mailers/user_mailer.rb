class UserMailer < ActionMailer::Base
  default from: "no-reply@example.com"

  def user_assigned_to_task_email(assigner, task) 
  	@assigner = assigner
  	@user = task.user
  	@task = task
  	mail(to: @user.email, subject: @task.name + ' was assigned to you')
  end

  def user_assignment_removed_email(assigner, user, task)
  	@assigner = assigner
  	@user = user
  	@task = task
  	mail(to: @user.email, subject: 'Your assignment to task ' + @task.name + ' was removed')
  end
end
