class CreateRelease < ActiveRecord::Migration[5.1]
  def change
    create_table :releases do |t|
      t.string :pull_request_reference, null: false
      t.string :story_reference, null: false
      t.string :description, null: false
      t.date :date, null: false, index: true
      t.string :git_user_slug, null: false, index: true
      t.integer :state, null: false, default: 0
      t.timestamp
    end
  end
end
