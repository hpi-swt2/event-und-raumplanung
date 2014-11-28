	class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :participant_count

      t.timestamps
    end
  end
end
