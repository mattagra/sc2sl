class UserSessionsController < ApplicationController
    authorize_resource

  def new
    @user_session = UserSession.new
  end

  def create

	  if current_user
		if current_user_session.associatable_with_facebook_connect?
		  if current_user_session.associate_with_facebook_connect
			flash[:notice] = "Your account is now associated with your facebook account"
			redirect_to root_url
		  end
		else
		  flash[:notice] = "Your facebook account is already connected"
		  redirect_to account_url
		end
	  else
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
		  flash[:notice] = "Login successful!"
		  redirect_back_or_default root_url
		else
		  if @user_session.errors.on(:facebook)
			flash[:notice] = "An account already exists with this email, please login to connect it with your Facebook account."
			redirect_to login_path
		  else
			flash[:notice] = "Login not succesful, please try again."
			render :action => :new
		  end
		end
	  end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_url
  end
end