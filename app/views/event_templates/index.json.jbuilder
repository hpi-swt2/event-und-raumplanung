json.array!(@event_templates) do |event_template|
  json.extract! event_template, :id, :name, :description, :start_date, :end_date, :start_time, :end_time
  json.url event_template_url(event_template, format: :json)
end
