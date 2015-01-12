class UserMailer < ActionMailer::Base
  default from: "no-reply@example.com"

  def user_assigned_to_task_email(assigner, task, user) 
    @group_assignment = false
    @group_name = "Testgruppe"
  	@assigner = assigner
  	@user = user
  	@task = task
    subject = @group_assignment ? ' was assigned to ' + @group_name : ' was assigned to you'
  	mail(to: @user.email, subject: @task.name + subject)
  end

  def user_assignment_removed_email(assigner, user, task)
    @group_assignment = false
    @group_name = "Testgruppe"
  	@assigner = assigner
  	@user = user
  	@task = task
    subject = @group_assignment ? 
        'The assignment of the group ' + @group_name +  ' to the task '
      : 'Your assignment to the task '
  	mail(to: @user.email, subject: subject + @task.name + ' was removed')
  end
end
