json.array!(@attachments) do |attachment|
	json.extract! attachment, :id, :title, :url, :task_id
	json.url attachment_url(attachment, format: :json)
end