json.array!(@equipment) do |equipment|
  json.extract! equipment, :id, :name, :description, :room_id
  json.url equipment_url(equipment, format: :json)
end
