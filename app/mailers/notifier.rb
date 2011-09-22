class Notifier < ActionMailer::Base
  # default :from => '<%= "#{Rails.application.class.parent_name}" %> <leonelsantosnet@gmail.com>'
  default :from => 'Helpmate <auto@helpmateapp.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.user_signedup.subject
  #
  def user_signedup(account_data)
  	@account_data = account_data
    mail	:to => account_data.companies[0].users[0].email,
    			:subject => "[" + account_data.companies[0].users[0].first_name + " " + account_data.companies[0].users[0].last_name + "] Welcome to your Helpmate site!"
  end
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.user_created.subject
  #
  def user_invited(user)
    @user = user
  	mail	:to => user.email,
  	# :from => @user.account_owner + " <leonelsantosnet@gmail.com>",
    :subject => "You're invited to join our helpdesk system"
  end
  
  def user_confirmed(user)
    @user = user
  	mail	:to => user.email,
  	# :from => "Helpmate <leonelsantosnet@gmail.com>",
    :subject => "Your account has been created"
  end
  
  def password_reset(user)
  	@user = user
  	mail :to => user.email, :subject => "Reset your password"
  end
  
  def password_updated(user)
  	@user = user
  	mail :to => user.email, :subject => "Helpmate password change"
  end
  
end
