json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :title, :url, :task_id
end