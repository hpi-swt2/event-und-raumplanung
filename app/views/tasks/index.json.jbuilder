json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description, :event_id, :deadline
  json.url task_url(task, format: :json)
end
