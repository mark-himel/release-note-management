class AddAndRenameColumnsIntoRelease < ActiveRecord::Migration[5.1]
  def up
    add_column :releases, :story_number, :string, null: false
    rename_column :releases, :pull_request_reference, :pr_reference
    add_column :releases, :pr_title, :string, null: false
    add_column :releases, :pr_identifier, :string, null: false
    add_column :releases, :user_id, :bigint, null: false, foreign_key: true, index: true
    remove_column :releases, :git_user_slug
  end

  def down
    remove_column :releases, :story_number
    rename_column :releases, :pr_reference, :pull_request_reference
    remove_column :releases, :pr_title
    remove_column :releases, :pr_identifier
    remove_column :releases, :user_id
    add_column :releases, :git_user_slug, :string, null: false
  end
end
