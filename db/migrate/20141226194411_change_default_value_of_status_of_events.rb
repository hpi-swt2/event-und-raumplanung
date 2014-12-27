class ChangeDefaultValueOfStatusOfEvents < ActiveRecord::Migration
  def change
    change_column :events, :status, :string, :default => 'pending'
  end
end
