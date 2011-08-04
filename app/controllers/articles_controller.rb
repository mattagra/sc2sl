class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml

  authorize_resource
  cache_sweeper :article_sweeper

  def index
    @current_page = (params[:page]|| 1).to_i
    @per_page = 20
    if current_admin
      if params[:tag]
        @articles = Article.tagged_with(params[:tag]).paginated(@current_page, @per_page)
        @articles_count = Article.tagged_with(params[:tag]).count
      else
        @articles = Article.paginated(@current_page, @per_page)
        @articles_count = Article.count
      end
    else
      if params[:tag]
        @articles = Article.tagged_with(params[:tag]).published.paginated(@current_page, @per_page)
        @articles_count = Article.tagged_with(params[:tag]).published.count
      else
        @articles = Article.published.paginated(@current_page, @per_page)
        @articles_count = Article.published.count
      end
    end

    @page = "Sc2SL News"
    @keywords += ["News", "Articles"]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
      format.rss { render :layout => false}
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    if params[:id]
      if current_admin
        @article = Article.find(params[:id])
      else
        @article = Article.find(params[:id]).published
      end
    elsif params[:url]
      date_start = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).midnight
      date_end = date_start + 1.day
      if current_admin
        @article = Article.where(:url => params[:url]).where("created_at between ? and ?", date_start, date_end).first
      else
        @article = Article.where(:url => params[:url]).where("created_at between ? and ?", date_start, date_end).published.first
      end
    end
    @comments = []
    unless  @article.nil?
      @comment = Comment.new_of_type(@article)
      @current_page = (params[:page] || 1).to_i
      @comments_count = @article.comments.count
      @per_page = 10
      @comments= @article.comments.paginated(@current_page, @per_page)

      @page = "SC2SL News"
      @subpage = @article.title
      @description = @article.summary
      @keywords += @article.tags
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

  def upload_image
    render :layout => false
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
      if params[:commit] == "Preview"
        format.html { render :action => "new" }
      elsif @article.save
        format.html { redirect_to( named_article_path(:year => @article.created_at.year, :month => @article.created_at.strftime("%m"), :day => @article.created_at.strftime("%d"), :url => @article.url), :notice => 'Article was successfully created.') }
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
      if params[:commit] == "Preview"
        format.html { render :action => "edit" }
      elsif @article.update_attributes(params[:article])
        format.html { redirect_to( named_article_path(:year => @article.created_at.year, :month => @article.created_at.strftime("%m"), :day => @article.created_at.strftime("%d"), :url => @article.url), :notice => 'Article was successfully updated.') }
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
