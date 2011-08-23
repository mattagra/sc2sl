
class TeamSweeper < ActionController::Caching::Sweeper
  observe Team
  # If our sweeper detects that a team was created call this
  def after_create(team)
          expire_cache_for(team)
  end

  # If our sweeper detects that a team was updated call this
  def after_update(team)
          expire_cache_for(team)
  end

  # If our sweeper detects that a team was deleted call this
  def after_destroy(team)
          expire_cache_for(team)
  end

  private
  def expire_cache_for(team)
    # Expire a fragment
    expire_fragment('season_rankings')
    #Potentially Expire Calendar. Maybe sometime in the future.
  end
end