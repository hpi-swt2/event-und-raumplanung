json.array!(@bookings) do |booking|
  json.extract! booking, :id, :name, :description, :start, :end, :event_id, :room_id
  json.url booking_url(booking, format: :json)
end
