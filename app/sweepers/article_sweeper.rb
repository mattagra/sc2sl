class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article
  # If our sweeper detects that a article was created call this
  def after_create(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that a article was updated call this
  def after_update(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that a article was deleted call this
  def after_destroy(article)
    expire_cache_for(article)
  end

  private
  def expire_cache_for(article)
    # Expire a fragment
    expire_fragment("recent_news")
    expire_fragment("articles_banner")
    expire_fragment("featured_article")
	expire_fragment("live_section")
    expire_fragment("frontpage_articles")
  end
end