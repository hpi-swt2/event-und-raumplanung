class AddIsLeaderToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :isLeader, :boolean, :default => false
  end
end
