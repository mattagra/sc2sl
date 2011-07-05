class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml

  before_filter :require_moderator,  :only => [:new, :edit, :create, :update]
  before_filter :require_admin, :only => [:destroy]

  def index
    if params[:tag]
      @articles = Article.tagged_with(params[:tag])
    else
      @articles = Article.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    if params[:id]
      @article = Article.find(params[:id])
    elsif params[:url]
      date_start = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).midnight
      date_end = date_start + 1.day
      @article = Article.where(:url => params[:url]).where("created_at between ? and ?", date_start, date_end).first
    end
    unless @article.nil?
    @comment = Comment.new_of_type(@article)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
    else
      render :file => "public/404.html", :status => 404, :layout => false
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  

end