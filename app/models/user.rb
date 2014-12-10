class User < ActiveRecord::Base
  has_many :tasks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  devise :openid_authenticatable, :rememberable
  has_and_belongs_to_many :groups

  def self.build_from_identity_url(identity_url)
    # to-do: find a sophisticated way to set the correct email right here
    User.new(:identity_url => identity_url, :email => '')
  end
end
