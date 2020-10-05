class CreateUserFromOmniAuth
  attr_accessor :auth

  def initialize(auth)
    @auth = auth
  end

  def self.call(auth)
    new(auth).call
  end

  def call
    create_or_update_user
  rescue => e
    ErrorReporter.error(e, github_username: auth.extra.raw_info.login)
    nil
  end

  def create_or_update_user
    User.where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.github_username = auth.extra.raw_info.login
      user.avatar_url = auth.extra.raw_info.avatar_url
      user.last_login_at = Time.now
      user.last_seen_at = Time.now
      user.role = custom_role_or_default(github_authorization.role)
      user.save!
    end
  end

  def github_authorization
    GithubAuthorization.new(
      auth.extra.raw_info.login,
      Global.github.access_token,
    )
  end

  def custom_role_or_default(default)
    value = ENV.fetch('DEFAULT_USER_ROLE', default)
    value.is_a?(Integer) ? User.roles.key(value) : value.to_sym
  end
end
