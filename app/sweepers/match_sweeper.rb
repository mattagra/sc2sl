class MatchSweeper < ActionController::Caching::Sweeper
  observe Match
  # If our sweeper detects that a match was created call this
  def after_create(match)
    expire_cache_for(match)
  end

  # If our sweeper detects that a match was updated call this
  def after_update(match)
    expire_cache_for(match)
  end

  # If our sweeper detects that a match was deleted call this
  def after_destroy(match)
    expire_cache_for(match)
  end

  private
  def expire_cache_for(match)
    # Expire a fragment
    expire_fragment("season_rankings")
    if match.scheduled_at and match.scheduled_at.year
      expire_fragment("calendar_#{match.scheduled_at.year}_#{match.scheduled_at.month}")
      if match.scheduled_at_changed? and match.scheduled_at_was and match.scheduled_at_was.year
        expire_fragment("calendar_#{match.scheduled_at_was.year}_#{match.scheduled_at_was.month}")
      end
    end
    expire_fragment("live_section")
    expire_fragment("matches/live")
	expire_fragment('recent_games')
  end
end