class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  has_many :events
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
