class AddGitProjectIdentifierToProjectSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :project_settings, :git_repo_identifier, :string
  end
end
