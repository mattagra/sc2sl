class AdvertisementSweeper < ActionController::Caching::Sweeper
  observe Advertisement
  # If our sweeper detects that a advertisement was created call this
  def after_create(advertisement)
          expire_cache_for(advertisement)
  end

  # If our sweeper detects that a advertisement was updated call this
  def after_update(advertisement)
          expire_cache_for(advertisement)
  end

  # If our sweeper detects that a advertisement was deleted call this
  def after_destroy(advertisement)
          expire_cache_for(advertisement)
  end

  private
  def expire_cache_for(advertisement)
    # Expire a fragment
    cache = ActiveSupport::Cache::MemCacheStore.new
    cache.delete("advertisments_#{advertisement.ad_type.to_s}")
    if advertisement.ad_type_changed? and advertisement.ad_type_was
      cache.delete("advertisements_#{advertisement.ad_type_was.to_s}")
    end
  end
end