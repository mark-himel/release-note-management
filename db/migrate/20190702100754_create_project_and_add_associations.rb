class CreateProjectAndAddAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.belongs_to :team, index: true, foreign_key: true, null: false
      t.string :name, null: false
    end
    add_index :projects, %i(team_id name), unique: true
    add_column :releases, :project_id, :integer, null: false, foreign_key: true, index: true
  end
end
