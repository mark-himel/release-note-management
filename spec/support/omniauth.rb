OmniAuth.config.test_mode = true
omniauth_hash = {
  'provider' => 'github',
  'uid' => '12345',
  'info' => {
    'name' => 'natasha',
    'email' => 'hi@natashatherobot.com',
  },
  'extra' => {
    'raw_info' => {
      'login' => 'mark-himel',
      'avatar_url' => 'www.abc.com/image'
    },
  },
  'credentials' => {
    'token' => SecureRandom.uuid,
  },
}
OmniAuth.config.add_mock(:github, omniauth_hash)
