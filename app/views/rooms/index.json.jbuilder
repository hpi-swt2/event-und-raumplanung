json.array!(@rooms) do |room|
  json.extract! room, :id, :name, :size, :booking_id
  json.url room_url(room, format: :json)
end
