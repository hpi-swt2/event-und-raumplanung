class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :fullname, :string, :default => ""
    add_column :users, :office_location, :string, :default => ""
    add_column :users, :office_phone, :string, :default => ""
    add_column :users, :mobile_phone, :string, :default => ""
    add_column :users, :language, :string, :default => "German"
    add_column :users, :email_notification, :boolean, :default => true
    add_column :users, :firstlogin, :boolean, :default => true
  end
end
