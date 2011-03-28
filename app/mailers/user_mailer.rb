class UserMailer < ActionMailer::Base
  default :from => "SC2 Stars Administration<admin@sc2stars.com>"

  def activation(user)
    @user = user
    mail(:to => "#{user.login} <#{user.email}>", :subject => "Activation Email")
  end

  def password_reset(user)
  @user = user
  mail(:to => "#{@user.login} <#{@user.email}>", :subject => "Password Reset Instructions")
  end


end
