class ChangeFormatOfDescriptionEventTemplate < ActiveRecord::Migration
  def up
    change_column :event_templates, :description, :text
  end

  def down
    change_column :event_templates, :description, :string
  end
end
