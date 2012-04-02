require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Sc2sl
  class Application < Rails::Application
  
  config.filter_parameters << :password << :password_confirmation
    config.action_mailer.default_url_options = {:host => "sc2sl.com"}
    config.time_zone = "Paris"
    Dir.glob("./lib/*.{rb}").each { |file| require file }
    IMGUR_API_KEY = "edb81443e23154af166573652a25544a"
    CUSTOM_BBCODE = {
      'Spoiler' => [
        /\[spoiler(:.*)?=(.*?)\](.*?)\[\/spoiler\1?\]/mi,
        '<div style="margin:20px; margin-top:5px"><div class="smallfont" style="margin-bottom:2px"><a href="#" onClick="if (this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display != \'\') { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'\'; return false; } else { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'none\'; return false; }">+ Show Spoiler - \2 +</a></div><div class="alt2" style="margin: 0px; padding: 6px; border: 2px groove threedface;"><div style="display: none;">\3</div></div></div>',
        'Spoiler with preview',
        '[spoiler=Game 2 Results]Huk Wins![/quote]',
        :spoiler
      ],
      'Spoiler (Sourceless)' => [
        /\[spoiler(:.*)?\](.*?)\[\/spoiler\1?\]/mi,
        '<div style="margin:20px; margin-top:5px"><div class="smallfont" style="margin-bottom:2px"><a href="#" onClick="if (this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display != \'\') { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'\'; return false; } else { this.parentNode.parentNode.getElementsByTagName(\'div\')[1].getElementsByTagName(\'div\')[0].style.display = \'none\'; return false; }">+ Show Spoiler +</a></div><div class="alt2" style="margin: 0px; padding: 6px; border: 2px groove threedface;"><div style="display: none;">\2</div></div></div>',
        'Spoiler with preview',
        '[spoiler=Game 2 Results]Huk Wins![/quote]',
        :spoiler
      ],
      'YouTube' => [
        /\[youtube\](.*?)\?v=([\w\d\-]+).*\[\/youtube\]/im,
        # '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
        '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="400" height="330"></embed></object>',
        'Display a video from YouTube.com',
        '[youtube]http://youtube.com/watch?v=E4Fbk52Mk1w[/youtube]',
        :video],
      'YouTube (Alternative)' => [
        /\[youtube\](.*?)\/v\/([\w\d\-]+)\[\/youtube\]/im,
        # '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" wmode="transparent" width="400" height="330"></embed></object>',
        '<object width="400" height="330"><param name="movie" value="http://www.youtube.com/v/\2"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/\2" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="400" height="330"></embed></object>',
        'Display a video from YouTube.com (alternative format)',
        '[youtube]http://youtube.com/watch/v/E4Fbk52Mk1w[/youtube]',
        :video],
      'Panda' => [
        /\[panda\](.*?)\/v\/([\w\d\-]+)\[\/panda\]/im,
        '',
        '',
        '',
        :panda],
      'Link' => [
        /\[url=(.*?)\](.*?)\[\/url\]/mi,
        '<a href="\1" rel="nofollow" target="_blank">\2</a>',
        'Hyperlink to somewhere else',
        'Maybe try looking on [url=http://google.com]Google[/url]?',
        :link],
      'Link (Implied)' => [
        /\[url\](.*?)\[\/url\]/mi,
        '<a href="\1" rel="nofollow" target="_blank">\1</a>',
        'Hyperlink (implied)',
        "Maybe try looking on [url]http://google.com[/url]",
        :link],
      'Link (Automatic)' => [
        /(\A|\s)((https?:\/\/|www\.)[^\s<]+)/,
        ' <a href="\2" rel="nofollow" target="_blank">\2</a>',
       'Hyperlink (automatic)',
        'Maybe try looking on http://www.google.com',
        :link]

    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/app/sweepers)
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

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1.1'
  end
end
