class CreateEventTemplates < ActiveRecord::Migration
  def change
    create_table :event_templates do |t|
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
