class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.boolean :is_favorite

      t.timestamps
    end
  end
end
