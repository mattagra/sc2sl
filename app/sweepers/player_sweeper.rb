class PlayerSweeper < ActionController::Caching::Sweeper
  observe Player
  # If our sweeper detects that a player was created call this
  def after_create(player)
    expire_cache_for(player)
  end

  # If our sweeper detects that a player was updated call this
  def after_update(player)
    expire_cache_for(player)
  end

  # If our sweeper detects that a player was deleted call this
  def after_destroy(player)
    expire_cache_for(player)
  end

  private
  def expire_cache_for(player)
    # Expire a fragment
    expire_fragment('recent_players')
    expire_fragment('season_rankings')
  end
end