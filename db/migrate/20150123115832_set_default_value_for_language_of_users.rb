class SetDefaultValueForLanguageOfUsers < ActiveRecord::Migration
  def change
  	change_column_default :users, :language, "de"
  end
end
