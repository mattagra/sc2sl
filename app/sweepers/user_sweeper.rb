class UserSweeper < ActionController::Caching::Sweeper
  observe User
  # If our sweeper detects that a game was created call this
  #def after_create(user)
  # expire_cache_for(game)
  #end

  # If our sweeper detects that a game was updated call this
  def after_update(user)
    expire_cache_for(user)
  end

  # If our sweeper detects that a game was deleted call this
  #def after_destroy(game)
  #        expire_cache_for(game)
  #end

  private
  def expire_cache_for(user)
    # Expire a fragment
    if user.player
      expire_fragment('recent_games')
    end
  end
end