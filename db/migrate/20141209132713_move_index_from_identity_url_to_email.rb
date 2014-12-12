class MoveIndexFromIdentityUrlToEmail < ActiveRecord::Migration
  def change
    remove_index :users, :identity_url
    add_index :users, :email, unique: true
    change_table :users do |t|
      t.change :identity_url, :string, null: true
      t.change :email, :string, null: false
    end
    change_column_default :users, :email, nil
  end
end
