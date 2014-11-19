class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :title
      t.string :url
      t.belongs_to :task, index: true

      t.timestamps
    end
  end
end
