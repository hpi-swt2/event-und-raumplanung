class ChangeEventScheduleDataTypeToText < ActiveRecord::Migration
  def change
    change_column :events, :schedule, :text
  end
end
