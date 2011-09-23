ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = 'helpmateapp.com'
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "creativodev.com",
  :user_name            => "auto@creativodev.com",
  :password             => "%R3hM7*q00",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
#   :address => "smtp.gmail.com",
#   :port => "587",
#   :domain => "gmail.com",
#   :authentication => "plain",
#   :user_name => "leonelsantosnet@gmail.com",
#   :password => "szg8gsvz",
#   :enable_starttls_auto => true
# }
