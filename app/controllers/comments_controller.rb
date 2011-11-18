class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  authorize_resource
  
  before_filter :deny_banned, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @current_page = (params[:page] || 1).to_i
    @per_page = 10
    @comments= Comment.newest.paginated(@current_page, @per_page)
    @comments_count = Comment.count
    @comment = Comment.new

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
    c = Comment.find(params[:comment_id])
    @comment.description = "[quote=\"On #{c.formatted_time} #{c.user.login} said:\"]#{c.description.to_s}[/quote]"
    @comment.external_id = c.external_id
    @comment.external_type = c.external_type

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
      redirect_to root_url
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    url_back = params[:back_url]
    
    respond_to do |format|
      if Comment.recent(current_user).count > 0
        flash[:warning]= "You may only post 1 comment every 30 seconds. Please wait and try again."
        format.html { render(:action => :new, :errors => @comment.errors) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      elsif @comment.save
        format.html { redirect_to(url_back+"?page=#{@comment.external_page}#comment_#{@comment.id}") }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        
        format.html { render(:action => :new, :errors => @comment.errors) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])
    url_back = params[:back_url]
    if current_user.is_moderator? or (@comment.user == current_user and !@comment.locked)
      respond_to do |format|
        if @comment.update_attributes(params[:comment])
          format.html { redirect_to(url_back+"#comment_#{@comment.id}")   }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = "You do not have permission to modify this. "
      redirect_to root_url
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
  
   protected

  def deny_banned
    if current_user.banned?
        flash[:warning]= "Good try, but you are banned. You may not post until your ban is completed."
        redirect_to root_url
    end
  end
  
  
end
