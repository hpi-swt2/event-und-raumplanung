class AddIsPrivateColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_private, :boolean
  end
end
