class ApplicationController < ActionController::Base
  before_action :authenticate, :current_user, :unauthenticate

  def current_user
    @_current_user ||= session[:current_user_id] && User.find_by_id(session[:current_user_id])
  end

  private

  def authenticate
    unless current_user
      redirect_to session_new_path
    end
  end

  def unauthenticate
    if current_user
      redirect_back fallback_location: root_path
    end
  end
end
