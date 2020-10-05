class StoreGitMergeInformation
  attr_reader :git_hook_data

  def initialize(git_hook_data)
    @git_hook_data = git_hook_data['pull_request']
  end

  def self.call(git_hook_data)
    new(git_hook_data).call
  end

  def call
    return unless user && project && git_hook_data['merged_at']

    existing_release = Release.find_by(pr_reference: git_hook_data['html_url'])
    release = existing_release || create_release
    update_release_description(release)
  end

  def create_release
    Release.create!(prepare_attributes_for_release)
  end

  def prepare_attributes_for_release
    {
      pr_title: git_hook_data['title'],
      pr_reference: git_hook_data['html_url'],
      pr_identifier: git_hook_data['number'],
      story_reference: jira_story_url,
      story_number: issue_number,
      description: git_hook_data['title'],
      date: Date.today,
      state: :pending,
      project: project,
      assignee: user
    }
  end

  def update_release_description(release)
    jira_project = jira_client.Project.find(project.settings.jira_project_slug)
    jira_issue = jira_project.issues.detect { |issue| issue.key == issue_number }
    return unless jira_issue

    html_description = JiraTextParser.call(jira_issue.description)
    release.update!(description: html_description)
  end

  def issue_number
    @issue_number ||= git_hook_data['head']['ref'].gsub(/^([A-Z]+-\d+)/).first
  end

  def jira_story_url
    "#{project.settings.jira_site}/browse/#{issue_number}"
  end

  def jira_client
    @jira_client ||= JIRA::Client.new(jira_client_options)
  end

  def team
    @organization ||= git_hook_data['head']['repo']['owner']['login']
    @team ||= Team.find_by(github_organization: @organization)
  end

  def project
    @project_name ||= git_hook_data['head']['repo']['name']
    @project ||= ProjectSetting.find_by(git_repo_identifier: @project_name).project
  end

  def user
    @user ||= User.find_by(github_username: git_hook_data['user']['login'])
  end

  def jira_client_options
    settings = project.settings
    {
      username: settings.jira_username,
      password: settings.jira_api_token,
      site: settings.jira_site,
      context_path: '',
      auth_type: :basic
    }
  end
end
