class ActivationsController < ApplicationController
    before_filter :require_no_user, :only => [:new]


    def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.month) || (raise Exception)

    #raise Exception if @user.active?

    if @user.activate!
      flash[:notice] = "Your account has been activated. You can now join or create a league."
      UserSession.create(@user, false)
      redirect_to account_url
    else
      flash[:notice] = "Please conact us immediately at EMAIL"
      redirect_to root_url
    end
  end

  end