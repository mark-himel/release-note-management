class ProjectSetting < ApplicationRecord
  belongs_to :project
  attr_encrypted :jira_api_token,
                 key: Global.jira.encryption_key,
                 mode: :per_attribute_iv
  validates_format_of :jira_username,
                      with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, if: :jira_username
  validate :urls

  private

  def urls
    return unless git_repo_url && jira_site

    errors.add(:git_repo_url, 'invalid url') if git_repo_url && !valid_url?(git_repo_url)
    errors.add(:jira_site, 'invalid url') if jira_site && !valid_url?(jira_site)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
