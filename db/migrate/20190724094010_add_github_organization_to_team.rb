class AddGithubOrganizationToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :github_organization, :string
  end
end
