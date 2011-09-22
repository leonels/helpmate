class InvitationsController < ApplicationController

	skip_before_filter :authorize, :only => [:show, :already_confirmed, :activate, :completed]
	before_filter :stay_inside_app, :only => [:show, :_already_confirmed, :activate, :completed]
	
	# Added by user
	# 1) users#create
	# 2) invitations#show
	# 3) invitations#activate
	# 4) invitations#completed
	
	# Resending invitation
	# 1) pre_resend
	# 2) resend
	# 3) show
	# 4) activate
	# 5) completed
	
	# From account owner control panel
	# Send user another invitation?
  def pre_resend
  	@user = User.find(params[:id])
  	if @user.user_state == "confirmed"
      flash[:notice] = "" + @user.first_name + ", your account is already confirmed."
      redirect_to(:action => 'already_confirmed', :id => params[:id])
    else
      render :layout => 'clean'
    end
  end
  
  # From account owner control panel
  # Resends invitation email
  def resend
  	@user = User.find(params[:id])
  	  	
  	if Notifier.user_invited(@user).deliver
  		@user.update_attributes(:invitation_last_sent_at => Time.now, :invitation_last_sent_to => @user.email)
  		flash[:notice] = "Instructions have been sent to " + @user.email
  		redirect_to(:controller => 'users', :action => 'edit', :id => params[:id])
  	else
      flash[:alert] = "Invitation could not be resent."
			redirect_to(:controller => 'users', :action => 'edit', :id => params[:id])
  	end
  end

  # Link sent by email
  # where the user choose his username/password
  # form will submit to 'activate'
  def show
  	@user = User.find_by_confirmation_token_and_id(params[:confirmation_token], params[:id])
  	if @user.user_state == "confirmed"
      flash[:notice] = "" + @user.first_name + ", your account is already confirmed."
      redirect_to(:action => 'already_confirmed')
    else
      render :layout => "activate"
    end
  end

  # where the choose username/password form submits to
  # where the actual confirmation happens
  # after successful confirmation redirect to 'completed'
  def activate
    @user = User.find(params[:id])

  	if @user.user_state == "confirmed"
      flash[:notice] = "" + @user.first_name + ", your account is already confirmed."
      redirect_to(:action => 'confirmed', :id => params[:id])
    else
			respond_to do |format|
				if @user.update_attributes(params[:user])
		  		@user.user_state = "confirmed"
					@user.confirmed_at = Time.now

					if @user.update_attributes(params[:user])						
						Notifier.user_confirmed(@user).deliver
						flash[:notice] = "You're all set, " + @user.first_name + "!"
						format.html { redirect_to(:action => 'completed', :id => params[:id]) }
					else
						flash[:error] = 'Failed to set user state to confirmed. Please try again.'
						format.html { render :action => "invitation", :layout => "activate" }
					end
						
				else
					flash[:error] = 'User was not updated.'
					format.html { render :action => "invitation", :layout => "activate" }
				end
			end
		end
  end

  # you're all set
  # we have sent an email with your sign in information
  def completed
  	@user = User.find(params[:id])
  	render :layout => "activate"
  end

  # if the user tries to access the page to choose username/password 
  # and the user is already confirmed  
  def already_confirmed
    @user = User.find_by_id(params[:id])
    confirmed_at = @user.confirmed_at
    @formatted_confirmed_at = confirmed_at.strftime("%A, %B %d, %Y at %I:%M%P")
  	render :layout => "activate"
  end
	
end
