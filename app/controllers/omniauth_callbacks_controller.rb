class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in @user, :event => :authentication
      respond_to do |format|
        format.html {redirect_to root_url}
        format.json {render :json => {"response" => "success"}}
      end
      return
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      respond_to do |format|
        format.html {redirect_to new_user_registration_url}
        format.json {render :json => {"response" => "failure"}}
      end
      return
    end
  end
end