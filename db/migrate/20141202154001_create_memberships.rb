class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.boolean :isLeader

      t.timestamps
    end
  end
end
