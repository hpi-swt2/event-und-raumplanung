<% js = escape_javascript(
  render(partial: 'event_templates/list',  locals: { event_templates: @event_templates,  model_class: EventTemplate })
) %>
$("#filterrific_results").html("<%= js %>");