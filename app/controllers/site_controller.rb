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

  def terms
    
  end

end
