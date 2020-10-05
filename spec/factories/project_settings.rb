FactoryBot.define do
  factory :project_setting do
    project
    git_repo_url { 'https://github.com' }
    git_repo_identifier { 'abc' }
    git_release_branch { 'master' }
    git_webhook_url { 'the_webhook_url' }
    jira_username { 'a@b.com' }
    jira_site { 'https://atlassian.net' }
    jira_project_slug { 'ABC' }
  end
end
