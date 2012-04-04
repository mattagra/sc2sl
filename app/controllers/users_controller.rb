class UsersController < ApplicationController
  authorize_resource




  def show
    if current_user and params[:login].nil?
      @user = current_user
      @comment = Comment.new_of_type(@user)
    elsif params[:login]
      @user = User.find_by_login!(params[:login])
      @comment = Comment.new_of_type(@user)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
    @current_page = [(params[:page]|| 1).to_i, 1].max
    @comments_count = @user.comments.count
    @comments= @user.comments.paginated(@current_page, 10)
	
	@layout_page = "Profile"
    @layout_subpage = @user.login
    @description = "Profile for #{@user.login}"
    @keywords += ["profile", @user.login]
	
  end

  def edit
    if params[:id] and current_user and current_user.is_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def update
    if params[:id] and current_user and current_user.is_admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    login = @user.login
    if @user.update_attributes(params[:user], !current_user.is_super_admin?)
      unless login == @user.login
        UserMailer.delay.username_change(@user, login)
      end
      flash[:notice] = "Account updated!"
      redirect_to profile_path(@user.login)
    else
      render :action => :edit
    end
  end
end