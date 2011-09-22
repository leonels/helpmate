class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # for use only for debugging
  # before_filter :clear_cookies
  
  helper_method :current_user
  
  helper_method :stay_inside_app
  
  before_filter :authorize

  private
  
  def current_user
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]

    # if cookies[:auth_token]
    if session[:user_id]
    	# @current_user = User.find_by_auth_token!(cookies[:auth_token])
    	# @current_user = User.find_by_auth_token!(session[:auth_token]) if session[:user_id]
    	@current_user ||= User.find_by_id!(session[:user_id]) if session[:user_id]
    else
      current_user = User.new
      current_user.role_id = 5
      @current_user = current_user
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
	 flash[:alert] = "Access denied."
	 redirect_to root_url
  end
  
  # for use only for debugging
  # not for production
  def clear_cookies
  	cookies.delete(:auth_token)
  end
  
  def authorize
  	# those roles mean that the user is logged in
  	# you could find a better way to find out
  	# if the user is logged in
  	# if session[:auth_token] could replace it
  	unless current_user.role_id == 1 or
  			current_user.role_id == 2 or
  			current_user.role_id == 3 or
  			current_user.role_id == 4
  		redirect_to log_in_path, :notice => 'Please log in'
  	end
  end
  
  def stay_inside_app
  	# those roles mean that the user is logged in
  	# you could find a better way to find out
  	# if the user is logged in
  	# if session[:auth_token] could replace it
  	if current_user.role_id == 1 or
  			current_user.role_id == 2 or
  			current_user.role_id == 3 or
  			current_user.role_id == 4
      redirect_to root_url, :notice => 'Log out first to access that page.'
    end
  end
  
end
