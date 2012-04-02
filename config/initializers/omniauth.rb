Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "109443772521540", "ef239daeeffc458b7a6276bd51d35e09",
           :scope => 'email', :display => 'popup'
end