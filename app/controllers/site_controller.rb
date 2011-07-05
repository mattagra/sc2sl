class SiteController < ApplicationController
  def index
    @article = Article.order('articles.id desc').where(:featured => true).first
  end

  def about
  end

  def contact
  end

  def privacy
    
  end

end
