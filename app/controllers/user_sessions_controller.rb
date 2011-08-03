class UserSessionsController < ApplicationController
    authorize_resource

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.reset_perishable_token!
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      flash[:notice] = "Login not succesful, please try again."
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_url
  end
end