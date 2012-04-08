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


end