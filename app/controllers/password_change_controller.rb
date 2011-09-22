class PasswordChangeController < ApplicationController

	def edit
    @user = User.find(params[:id])
	end
	
	def update
		# @user = User.find(current_user.id)
		@user = User.find(params[:id])
			respond_to do |format|
				# if @user.update_attributes(params[:user])
				# 	Notifier.password_updated(@user).deliver
				# 	flash[:notice] = 'Password updated. A password change notification has been sent to your email.'
				# 	format.html { redirect_to(:action => 'edit', :controller => 'users') }
				# else
				# 	flash[:error] = 'Password was not updated.'
					format.html { render "edit" }
				# end
			end
  end
end
