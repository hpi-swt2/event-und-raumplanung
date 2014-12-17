require 'devise_openid_authenticatable/strategy'

class Devise::Strategies::EuROpenidAuthenticatable < Devise::Strategies::OpenidAuthenticatable
  def find_resource
    mapping.to.find_by_email(session[:email])
  end

  def build_resource
    mapping.to.build_from_email(session[:email])
  end

  def create_resource
    mapping.to.build_from_email(session[:email])
  end
end
