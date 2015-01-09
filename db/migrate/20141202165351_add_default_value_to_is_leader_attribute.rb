class AddDefaultValueToIsLeaderAttribute < ActiveRecord::Migration
  def change
  	change_column :memberships, :isLeader, :boolean, :default => false
  end
end
