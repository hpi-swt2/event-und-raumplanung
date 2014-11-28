class ChangeDataTypeForStartDate < ActiveRecord::Migration
 def up
    change_table :events do |t|
      t.datetime :starts_at
      t.remove :start_date
      t.remove :start_time
      t.datetime :ends_at
      t.remove :end_date
      t.remove :end_time
    end
  end
  def down
    change_table :events do |t|
      t.remove :starts_at
      t.date :start_date
      t.time :start_time
      t.remove :ends_at
      t.date :end_date
      t.time :end_time
    end
  end
end
