# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sc2sl::Application.initialize!


if defined?(PhusionPassenger)
 PhusionPassenger.on_event(:starting_worker_process) do |forked|
   if forked
     Rails.cache.instance_variable_get(:@data).reset if Rails.cache.class == ActiveSupport::Cache::MemCacheStore
   end
 end
end