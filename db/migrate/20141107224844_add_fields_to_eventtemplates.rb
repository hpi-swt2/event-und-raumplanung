class AddFieldsToEventtemplates < ActiveRecord::Migration
  def change
    add_reference :event_templates, :user, index: true
    add_reference :event_templates, :room, index: true
  end
end

