class ChangeUseridFormatInCommentsTable < ActiveRecord::Migration
  def down
    change_column :comments, :user_id, :integer
  end

  def up
    change_column :comments, :user_id, :string
  end
end
