json.array!(@equipment) do |equipment|
  json.extract! equipment, :id
  json.url equipment_url(equipment, format: :json)
end
