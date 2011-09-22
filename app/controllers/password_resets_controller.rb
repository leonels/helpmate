class PasswordResetsController < ApplicationController

	skip_before_filter :authorize, :only => [:new, :create, :edit, :update]
  before_filter :stay_inside_app, :only => [:new, :create, :edit, :update]
	
  def new
  	render :layout => "reset"
  end

  def create
  	user = User.find_by_email(params[:email])
  	
  	if user && user.user_state == 'invited'
  		redirect_to new_password_reset_path, :alert => "Your account hasn't been confirmed yet. Please click in the confirmation link that was sent to your email. If you didn't receive an account confirmation email please ask your account administrator to resend it."
    elsif user
    	user.send_password_reset
      redirect_to log_in_path, :notice => "Instructions for signing in have been emailed to you."
    else
    	redirect_to new_password_reset_path, :alert => "Sorry, we couldn't find anyone with that email address."
    end
  end
  
  def edit
  	@user = User.find_by_password_reset_token!(params[:id])
  	render :layout => "reset"
  end

  def update
  	@user = User.find_by_password_reset_token!(params[:id])
  	if @user.password_reset_sent_at < 2.hours.ago
  		redirect_to new_password_reset_path, :alert => "Password reset has expired."
  	elsif @user.update_attributes(params[:user])
  		redirect_to root_url, :notice => "Password has been reset!"
  	else
  		render :edit, :layout => "reset"
  	end
  end  
end
