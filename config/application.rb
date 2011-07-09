require File.expand_path('../boot', __FILE__)
require 'net/http' 
require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Sc2sl
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    Dir.glob("./lib/*.{rb}").each { |file| require file }
    config.filter_parameters << :password << :password_confirmation
    config.action_view.javascript_expansions[:defaults] = %w(jquery)
    IMGUR_API_KEY = "edb81443e23154af166573652a25544a"
    CUSTOM_BBCODE = {
      'Spoiler' => [
        /\[spoiler(:.*)?=(.*?)\](.*?)\[\/spoiler\1?\]/mi,
        '<div style="margin:20px; margin-top:5px"><div class="smallfont" style="margin-bottom:2px"><a href="#" onClick="if (this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display != \'\') { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'\'; return false; } else { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'none\'; return false; }">+ Show Spoiler - \2 +</a></div><div class="alt2" style="margin: 0px; padding: 6px; border: 1px inset;"><div style="display: none;">\3</div></div></div>',
        'Spoiler with preview',
        '[spoiler=Game 2 Results]Huk Wins![/quote]',
        :spoiler
      ]
    }

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
