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
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: Welcome to the SC2SL!")
  end

  def warning(user, moderation)
    @user = user
    @moderation = moderation
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: You have been warned for recent activity.")
  end

  def ban(user, moderation)
    @user = user
    @moderation = moderation
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: You have been temporarily banned for recent activity.")
  end

  def permaban(user, moderation)
    @user = user
    @moderation = moderation
    mail(:to => "#{@user.login} <#{@user.email}>", :subject => "SC2SL: You have been banned for recent activity.")
  end

end
