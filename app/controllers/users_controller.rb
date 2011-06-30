class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.login = params[:user][:login]
    if @user.save
      flash[:notice] = "Thank you for registering. Please check your email to confirm your information before proceding."
      UserMailer.activation(@user).deliver
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
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
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
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end