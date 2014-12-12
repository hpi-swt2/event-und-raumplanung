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

  def event_accepted_email_with_message(user, event, message)
    @user = user
    @message = message
    @event = event

    subject = 'Your event has been approved'

    mail(to: @user.email, subject: subject)
  end

  def event_declined_email_with_message(user, event, message)
    @user = user
    @event = event
    @message = message

    subject = 'Your event has been declined'

    mail(to: @user.email, subject: subject)
  end

  def event_accepted_email_without_message(user, event)
    @user = user
    @event = event

    subject = 'Your event has been approved'

    mail(to: @user.email, subject: subject)
  end

  def event_declined_email_without_message(user, event)
    @user = user
    @event = event

    subject = 'Your event has been declined'

    mail(to: @user.email, subject: subject)
  end

end
