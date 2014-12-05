module TasksHelper
  def public_url(file_id, file_name)
    return "/files/" + file_id.to_s + "/" + file_name
  end
end
