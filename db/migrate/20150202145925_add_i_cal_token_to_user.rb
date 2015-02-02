class AddICalTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :icaltoken, :string
    add_index :users, :icaltoken, unique: true
  end
end
