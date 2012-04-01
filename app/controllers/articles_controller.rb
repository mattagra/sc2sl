class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml

  authorize_resource
  cache_sweeper :article_sweeper

  def index
    @current_page = [(params[:page]|| 1).to_i, 1].max
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

    @layout_page = "Sc2SL News"
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
	  zone = ActiveSupport::TimeZone.new("Paris")
      date_start = DateTime.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).in_time_zone(zone).midnight
	  
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
      @current_page = [(params[:page]|| 1).to_i, 1].max
      @comments_count = @article.comments.count
      @comments= @article.comments.paginated(@current_page, 10)

      @layout_page = "SC2SL News"
      @layout_subpage = @article.title
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



  def upload_image
    render :layout => false
  end



  

end
