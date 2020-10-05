Global.configure do |config|
  config.environment = Rails.env.to_s
  config.config_directory = Rails.root.join('config/settings').to_s
end
