require 'omniauth'

OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:post]

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'omniauth-github'
  provider :github,
    Global.github.client_id,
    Global.github.client_secret,
    scope: 'user:email',
    client_options: {
      site: Global.github.api_url,
      authorize_url: "#{Global.github.web_url}/login/oauth/authorize",
      token_url: "#{Global.github.web_url}/login/oauth/access_token"
    }
end
