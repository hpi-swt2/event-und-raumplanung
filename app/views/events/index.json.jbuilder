json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :participant_count, :start_date, :end_date, :start_time, :end_time
  json.url event_url(event, format: :json)
end
