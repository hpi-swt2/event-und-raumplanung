class CreateAssignables < ActiveRecord::Migration
  def change
    create_table :assignables do |t|
      t.string :type
      t.string   "email"
	  t.string   "username"
	  t.string   "encrypted_password"
	  t.string   "status"
	  t.string   "reset_password_token"
	  t.datetime "reset_password_sent_at"
	  t.datetime "remember_created_at"
	  t.integer  "sign_in_count"
	  t.datetime "current_sign_in_at"
	  t.datetime "last_sign_in_at"
	  t.string   "current_sign_in_ip"
	  t.string   "last_sign_in_ip"
	  t.string   "identity_url"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	  t.boolean  "student"
	  t.string	 "name"
      t.timestamps
    end
  end
end
