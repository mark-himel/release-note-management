class ChangeColumnTypeAndName < ActiveRecord::Migration[5.1]
  def change
    add_reference :releases, :project, null: false, index: true, foreign_key: true
    change_column :releases, :description, :text
    rename_column :project_settings, :jira_key, :jira_project_slug
  end
end
