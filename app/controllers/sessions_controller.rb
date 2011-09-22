class SessionsController < ApplicationController
	
	skip_before_filter :authorize, :only => [:new, :create]
  before_filter :stay_inside_app, :only => [:new, :create]
  
  def new
  	render :layout => "login"
  end

  def create
  	user = User.authenticate(params[:username], params[:password])
  	if user
  		# if params[:remember_me]
  		# 	cookies.permanent[:auth_token] = user.auth_token
  		# else
  		# 	cookies[:auth_token] = user.auth_token
  		# end
  		session[:user_id] = user.id
  		session[:auth_token] = user.auth_token
  		redirect_to root_url, :notice => 'Logged in!'
  	else
  		flash.now.alert = "We didn't recognize the username or password  you entered. Please try again."
  		render 'new', :layout => "login"
  	end
  end
  
  def destroy
      cookies.delete(:auth_token)
      session.delete(:user_id)
      session.delete(:auth_token)
      redirect_to log_in_path, :notice => 'Logged out!'
  end
  
end
