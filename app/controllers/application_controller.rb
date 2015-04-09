class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include LoginsHelper

  private

  def current_user
  	@current_user ||= if session[:user_id]
  		User.find_by_id(session[:user_id])
  	end
  end

  def integrated?
    return !current_user.app_key.blank?
  end


  helper_method :current_user, :integrated?
end
