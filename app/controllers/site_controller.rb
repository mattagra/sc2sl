class SiteController < ApplicationController
  def index
    @article = Article.latest.featured.published.first
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

end
