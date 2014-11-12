class AddEquipmentTypeToEquipment < ActiveRecord::Migration
  def change
  	add_column :equipment, :category, :string
  end
end
