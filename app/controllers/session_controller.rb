class SessionController < ApplicationController
  skip_before_action :authenticate, only: [:new,:create]
  skip_before_action :unauthenticate, except: [:create, :new]

  def new
  end

  def create
    user = User.find_by_login(params[:login])
    if user&.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to main_edit_path
    else
      flash[:error_log_in] = "Invalid login/password combination"
      redirect_to session_new_path
    end
  end

  def destroy
    session.delete(:current_user_id)
    @_current_user=nil
    redirect_to root_path
  end
end
