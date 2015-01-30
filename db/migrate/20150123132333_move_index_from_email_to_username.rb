class MoveIndexFromEmailToUsername < ActiveRecord::Migration
  def change
  	remove_index :users, :email
    add_index :users, :username, unique: true
    change_table :users do |t|
      t.change :email, :string, null: true
      t.change :username, :string, null: false
    end
    change_column_default :users, :email, nil
  end
end
