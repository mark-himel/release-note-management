class JiraTextParser
  attr_accessor :unformatted_text

  def initialize(unformatted_text)
    @unformatted_text = unformatted_text
  end

  def self.call(unformatted_text)
    new(unformatted_text).call
  end

  def call
    RestClient.post(Global.jira.api_urls.render, prepare_payload, content_type: :json).body
  rescue => e
    ErrorReporter.call(e)
    unformatted_text
  end

  def prepare_payload
    {
      rendererType: 'atlassian-wiki-renderer',
      unrenderedMarkup: unformatted_text
    }.to_json
  end
end
