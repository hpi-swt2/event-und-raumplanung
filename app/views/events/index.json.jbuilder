json.array!(@events) do |event|
  json.extract! event, :id, :name, :description, :participant_count
  json.url event_url(event, format: :json)
end
