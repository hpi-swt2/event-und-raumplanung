class UserMailer < ActionMailer::Base
  default from: "no-reply@example.com"

  def user_assigned_to_task_email(user, task) 
  	@user = user
  	@task = task
  	mail(to: @user.email, subject: @task.name + ' was assigned to you')
  end

  def event_accepted_email(user, event, message)
    @user = user
    @message = message
    @event = event

    subject = 'Your event has been approved'

    mail(to: @user.email, subject: subject)
  end

  def event_declined_email(user, event, message)
    @user = user
    @event = event
    @message = message

    subject = 'Your event has been declined'

    mail(to: @user.email, subject: subject)
  end

end
