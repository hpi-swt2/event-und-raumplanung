class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  devise :openid_authenticatable, :rememberable

  def self.build_from_identity_url(identity_url)
    User.new(:identity_url => identity_url)
  end
end
