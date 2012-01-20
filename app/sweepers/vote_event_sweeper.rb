class VoteEventSweeper < ActionController::Caching::Sweeper
  observe VoteEvent
  # If our sweeper detects that a article was created call this
  def after_create(vote)
    expire_cache_for(vote)
  end

  # If our sweeper detects that a article was updated call this
  def after_update(vote)
    expire_cache_for(vote)
  end

  # If our sweeper detects that a article was deleted call this
  def after_destroy(vote)
    expire_cache_for(vote)
  end

  private
  def expire_cache_for(vote)
    # Expire a fragment
    expire_fragment('vote_events_show')
	expire_fragment('live_section')
  end
end