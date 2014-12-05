class User < ActiveRecord::Base
  has_many :tasks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # If you add an option, be sure to inspect the migration file
  # "devise_create_user" and uncomment the appropriate section
  devise :openid_authenticatable, :rememberable
  has_many :memberships
  has_many :groups, through: :memberships

  def self.build_from_identity_url(identity_url)
    User.new(:identity_url => identity_url)
  end
  def self.openid_required_fields
    ["http://axschema.org/contact/email"]
  end 
  def is_leader_of_group (groupID)
    return self.memberships.select{|membership| membership.group_id == groupID}.first.isLeader
  end
    
  def openid_fields=(fields)
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
