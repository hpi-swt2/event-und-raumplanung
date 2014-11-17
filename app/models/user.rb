class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  devise :openid_authenticatable, :rememberable

  def self.build_from_identity_url(identity_url)
    User.new(:identity_url => identity_url)
  end
  def self.openid_required_fields
    ["http://axschema.org/namePerson/first", "http://axschema.org/contact/email"]
  end 
    
  def openid_fields=(fields)
    # TODO
    logger.info "OPENID FIELDS: #{fields.inspect}"
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end
    
      case key.to_s
        when "http://axschema.org/contact/email"
          self.email = value
        else
          logger.error "Unknown OpenID field: #{key}"
      end
    end
  end
end
