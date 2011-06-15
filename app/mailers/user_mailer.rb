class UserMailer < ActionMailer::Base
  default :from => "Michael<michael.darmousseh@gmail.com>"

  def activation(user)
    @user = user
    mail(:to => "#{user.login} <#{user.email}>", :subject => "Activation Email")
  end

  def password_reset(user)
  @user = user
  mail(:to => "#{@user.login} <#{@user.email}>", :subject => "Password Reset Instructions")
  end


end
