class AddIsImportantToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_important, :boolean
  end
end
