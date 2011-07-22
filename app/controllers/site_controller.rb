class SiteController < ApplicationController

  before_filter :current_user
  
  def index
    @article = Article.latest.featured.published
    @games = Game.where("games.result is not null").order(:updated_at).limit(10)
    @date = params[:month] ? Date.new(params[:year].to_i,params[:month].to_i, 1) : Date.today
    @matches = Match.where(:scheduled_at => (@date.beginning_of_month - 1)..(@date.end_of_month + 1))
    @season = Season.where(:published => true).limit(1)
  end

  def about
  end

  def contact
  end

  def privacy
    
  end

  def faq
    
  end

  def finish_registration

  end

  def finish_activation
    
  end

  def terms
    render :layout => false
    
  end

  def live
    @article = Article.latest.featured.published.first
    @games = Game.where("games.result is not null").order(:updated_at).limit(10)
    @matches = Match.all
    @date = params[:month] ? Date.new(params[:year].to_i,params[:month].to_i, 1) : Date.today
    @season = Season.where(:published => true).limit(1).first
  end

  def sitemap
    @static_pages = ["live", "terms", "faq", "", "about", "contact", "privacy"]
    @articles = Article.all
    @matches = Match.all
    @teams = Team.all
    @players = Player.all
    respond_to do |format|
      format.xml
    end
  end

end
