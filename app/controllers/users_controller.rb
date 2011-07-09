class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_moderator, :only => [:index]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.login = params[:user][:login]
    @user.email = params[:user][:email]
    if verify_recaptcha(:model => @user, :message => "The security code you entered was incorrect.") and @user.save
      flash[:notice] = "Thank you for registering. Please check your email to confirm your information before proceding."
      UserMailer.activation(@user).deliver
      redirect_to root_url
    else
      flash[:notice] = "Some errors prevented you from registering "
      render :action => :new
    end
  end

  def index
    @users = User.all
  end

  def show
    if current_user and params[:login].nil?
      @user = @current_user
      @comment = Comment.new_of_type(@user)
    elsif params[:login]
      @user = User.find_by_login(params[:login])
      @comment = Comment.new_of_type(@user)
    else
      flash[:params] = "Cannot Find a User with that name"
      redirect_to root_url
    end
    @current_page = (params[:page].to_i || 0)
    @comments_count = @user.comments.count
    @comments= @user.comments.paginated(10, @current_page)
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
    if @user.update_attributes(params[:user], !current_user.is_admin?)
      unless login == @user.login
        UserMailer.username_change(@user, login).deliver
      end
      flash[:notice] = "Account updated!"
      redirect_to profile_path(@user.login)
    else
      render :action => :edit
    end
  end
end