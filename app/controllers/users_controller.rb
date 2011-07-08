class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

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
      if RAILS_ENV == "development"
        flash[:notice] += "No email was sent, to active your account click <a href='#{activate_url(@user.perishable_token)}' >here</a>"
      end

      redirect_to root_url
    else
      flash[:notice] = "Some errors prevented you from registering "
      render :action => :new
    end
  end

  def show
    if current_user and params[:id].nil?
      @user = @current_user
      @comment = Comment.new_of_type(@user)
    elsif params[:id]
      @user = User.find(params[:id])
      @comment = Comment.new_of_type(@user)
    else
      flash[:params] = "Cannot Find a User with that ID"
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
    if params[:attachment]
      @attachment = Attachment.new
      @attachment.uploaded_file = params[:attachment]

      if @attachment.save
        flash[:notice] = "Thank you for your submission..."
        @user.attachment_id = @attachment.id
      else
        flash[:error] = "There was a problem submitting your attachment."
      end
    end
    if @user.update_attributes(params[:user], !current_user.is_admin?)
      flash[:notice] = "Account updated!"
      redirect_to profile_path(@user)
    else
      render :action => :edit
    end
  end
end