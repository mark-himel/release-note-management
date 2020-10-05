require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReleaseNoteManagement
  class Application < Rails::Application
    config.load_defaults 5.1
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.enabled = true
    config.assets.paths << Rails.root.join('app', 'assets', 'icons')

    STDOUT.sync = true
    config.log_tags = {
      request_id: :request_id,
      remote_ip: :remote_ip,
      subdomain: :subdomain
    }
    config.rails_semantic_logger.add_file_appender = false
    config.semantic_logger.add_appender(file_name: 'log/development.log', formatter: :json)

    if Rails.env.staging? || Rails.env.production?
      config.rails_semantic_logger.add_file_appender = false
      config.rails_semantic_logger.format = :json
      config.semantic_logger.application = 'ReleaseApp'
      config.semantic_logger.add_appender(io: STDOUT,
                                          level: config.log_level,
                                          formatter: config.rails_semantic_logger.format)
    end
  end
end
