class UserMailer < ActionMailer::Base
  default :from => "Michael<michael.darmousseh@gmail.com>"

  def activation(user)
    @user = user
    mail(:to => "#{user.login} <#{user.email}>", :subject => "SC2SL: Account activation")
  end

  def password_reset(user)
    @user = user
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: Password Reset")
  end

  def username_change(user, old_login)
    @user = user
    @reason = reason
    @old_login = old_login
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: New Username")
  end

  def welcome(user)
    @user = user
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "Welcome to the SC2SL!")
  end


end
