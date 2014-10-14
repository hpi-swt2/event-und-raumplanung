class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "add_devise_to_user" and uncomment the appropriate section
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
