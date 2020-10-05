Clearance.configure do |config|
  config.allow_sign_up = true
  config.routes = true
  config.mailer_sender = 'mark.mondol@welldev.io'
  config.sign_in_guards = [ConfirmedUserGuard]
  config.rotate_csrf_on_sign_in = true
end
