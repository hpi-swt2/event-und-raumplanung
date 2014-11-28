json.array!(@roomProperties) do |roomProperty|
  json.extract! roomProperty, :id, :name
  json.url room_url(roomProperty, format: :json)
end
