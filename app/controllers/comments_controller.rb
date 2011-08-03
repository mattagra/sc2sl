class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  authorize_resource

  def index
    @current_page = (params[:page] || 1).to_i
    @per_page = 10
    @comments= Comment.newest.paginated(@per_page, @current_page)
    @comments_count = Comment.count
    @comment = Comment.new_of_type(@comment)

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
    @comment.description = "[quote:#{c.id}=\"On #{c.formatted_time} #{c.user.login} said:\"]#{c.description.to_s}[/quote:#{c.id}]"
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
      redirect_to :root_url
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
        format.html { render(:action => :new, :errors => @comment.errors, :warning => "You may only post 1 comment every 30 seconds. Please wait and try again.") }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      elsif @comment.save
        format.html { redirect_to(url_back+"#comment_#{@comment.id}") }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render(:action => :new, :errors => @comment.errors, :warning => "All entries must be at least 5 characters and at most 750.") }
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