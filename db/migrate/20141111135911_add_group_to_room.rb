class AddGroupToRoom < ActiveRecord::Migration
  def change
    add_reference :rooms, :group, index: true
  end
end
