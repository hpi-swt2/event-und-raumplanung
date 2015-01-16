class LocaleController < ApplicationController
  def change_locale
    l = params[:locale].to_s.strip.to_sym
    l = I18n.default_locale unless I18n.available_locales.include?(l)
    current_user.language = l
    current_user.save
    redirect_to request.referer || root_url
  end
end
