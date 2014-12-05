class AddApprovedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean
  end
end
