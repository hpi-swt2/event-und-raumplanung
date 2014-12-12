json.array!(@event_suggestions) do |event_suggestion|
  json.extract! event_suggestion, :id, :starts_at, :datetime, :ends_at, :datetime, :status, :room_id
  json.url event_suggestion_url(event_suggestion, format: :json)
end
