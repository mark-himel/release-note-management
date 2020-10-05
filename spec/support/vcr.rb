require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.default_cassette_options = {
      record: :once,
      match_requests_on: [:method, :uri, :body],
  }

  config.debug_logger = File.open('log/vcr.log', 'w') if ENV['VCR_DEBUG'].present?

  config.filter_sensitive_data('$GithubAccessToken$') { Global.github.access_token }
  config.filter_sensitive_data('$JiraApiToken$') { ENV['JIRA_API_TOKEN'] }
  config.filter_sensitive_data('$JiraRestApiUrl$') { Global.jira.api_urls.render }
  config.filter_sensitive_data('$AuthorizationBasicToken') do |interaction|
    interaction.request.headers['Authorization']&.first
  end
end
