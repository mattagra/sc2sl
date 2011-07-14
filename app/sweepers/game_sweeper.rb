class GameSweeper < ActionController::Caching::Sweeper
  observe Game
  # If our sweeper detects that a game was created call this
  def after_create(game)
          expire_cache_for(game)
  end

  # If our sweeper detects that a game was updated call this
  def after_update(game)
          expire_cache_for(game)
  end

  # If our sweeper detects that a game was deleted call this
  def after_destroy(game)
          expire_cache_for(game)
  end

  private
  def expire_cache_for(game)
    # Expire a fragment
    expire_fragment('recent_games')
    expire_fragment('season_rankings')
  end
end