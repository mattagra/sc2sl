Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "162853603828753", "925f5163bf2fe45586dabf7966c565b2",
           :scope => 'email', :display => 'popup'
end