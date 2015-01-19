class AddScheduleToEvents < ActiveRecord::Migration
  def change
    add_column :events, :schedule, :string
  end
end
