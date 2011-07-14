class SiteController < ApplicationController

  
  def index
    @article = Article.latest.featured.published.first
    @games = Game.where("games.result is not null").order(:updated_at).limit(10)
    @matches = Match.all
    @date = params[:month] ? Date.new(params[:year].to_i,params[:month].to_i, 1) : Date.today
  end

  def about
  end

  def contact
  end

  def privacy
    
  end

  def faq
    
  end

  def terms
    render :layout => false
    
  end

  def live
    
  end

end
