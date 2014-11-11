class AddStatusToEvents < ActiveRecord::Migration
  def change
  	  	add_column :events, :status, :string
  end
end
