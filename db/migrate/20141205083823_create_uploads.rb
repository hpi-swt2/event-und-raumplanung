class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|

      t.references :task, polymorphic: true
      t.timestamps
    end
  end
end
