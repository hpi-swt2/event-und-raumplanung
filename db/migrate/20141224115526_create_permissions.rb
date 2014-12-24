class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.belongs_to :room, index: true
      t.belongs_to :permitted_entity, polymorphic: true
      t.column :type, :integer
      t.timestamps
    end
  end
end
