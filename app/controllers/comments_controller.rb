class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  before_filter :require_user, :only => [:new, :create, :update, :edit]
  before_filter :require_moderator, :only => [:destroy]

  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    unless current_user.is_moderator? or @comment.user == current_user
      flash[:notice] = "You do not have permission to modify this. "
      redirect_to :root_url
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    url_back = params[:url]
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(url_back) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { redirect_to(url_back, :errors => @comment.errors, :notice => "All entries must be at least 5 characters and at most 750.") }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    url_back = params[:url]
    if current_user.is_moderator? or @comment.user == current_user
      respond_to do |format|
        if @comment.update_attributes(params[:comment])
          format.html { redirect_to url_back  }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "You do not have permission to modify this. "
      redirect_to :root_url
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
