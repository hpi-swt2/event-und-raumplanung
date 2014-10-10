json.array!(@bookings) do |booking|
  json.extract! booking, :id, :name, :description, :start, :stop
  json.url booking_url(booking, format: :json)
end
