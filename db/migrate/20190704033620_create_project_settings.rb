class CreateProjectSettings < ActiveRecord::Migration[5.1]
  enable_extension 'citext'
  def change
    create_table :project_settings do |t|
      t.belongs_to :project, null: false, index: true, foreign_key: true
      t.string :git_repo_url
      t.string :git_release_branch
      t.string :git_webhook_url
      t.citext :jira_username
      t.string :encrypted_jira_api_token
      t.string :encrypted_jira_api_token_iv
      t.string :jira_site
      t.string :jira_key
    end
  end
end
