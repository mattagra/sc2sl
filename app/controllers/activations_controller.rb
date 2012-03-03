class ActivationsController < ApplicationController
    before_filter :require_no_user, :only => [:new]


    def new
    @user = User.where(:perishable_token => params[:activation_code])

    raise Exception if @user.active?

    if @user and @user.activate!
      flash[:notice] = "Your account has been activated. Thank you for joining"
      UserMailer.delay.welcome(@user)
      UserSession.create(@user, false)
      redirect_to finish_activation_url
    else
      flash[:notice] = "There was a problem, please contact us immediately or check your email to make sure you copied the link correctly."
      redirect_to root_url
    end
  end

  end