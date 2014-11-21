module TasksHelper

  def get_email(id)
    return User.find(id).email
  end

end
