class ApplicationController < ActionController::Base
  before_action :authenticate, :current_user, :unauthenticate
  around_action :switch_locale

  def current_user
    @_current_user ||= session[:current_user_id] && User.find_by_id(session[:current_user_id])
  end

  private

  def authenticate
    redirect_to session_new_path unless current_user
  end

  def unauthenticate
    redirect_back fallback_location: root_path if current_user
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
