class AddDefaultIsPrivateToEvents < ActiveRecord::Migration
  def change
    change_column :events, :is_private, :boolean, :default => true
  end
end
