module TasksHelper

  def public_url(file_id, file_name)
    return "/files/" + file_id.to_s + "/" + file_name
  end

  def has_attached_items?(task)
    return task.attachments.count() > 0 || task.uploads.count() > 0
  end
end
