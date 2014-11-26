class AddParticipantCountTpEventTemplates < ActiveRecord::Migration
  def change
  	 add_column :event_templates, :participant_count, :integer
  	 remove_column :event_templates, :end_date, :date
  	 remove_column :event_templates, :start_date, :date
  	 remove_column :event_templates, :end_time, :time
  	 remove_column :event_templates, :start_time, :time
  	 remove_reference :event_templates, :room
  end
end
