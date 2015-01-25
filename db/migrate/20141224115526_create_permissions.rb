class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.belongs_to :room, index: true
      t.belongs_to :permitted_entity, polymorphic: true
      t.column :category, :integer, index: true
      t.index [:permitted_entity_id, :permitted_entity_type], name: 'index_permissions_on_permitted_entity'
      t.timestamps
    end
  end
end
