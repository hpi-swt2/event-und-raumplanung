class CreateIdentityPolymorphism < ActiveRecord::Migration
  def change
  	remove_reference :tasks, :user
  	add_reference :tasks, :identity, polymorphic: true, index: true    
  end
end