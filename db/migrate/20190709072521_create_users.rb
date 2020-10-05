class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :oauth_token, null: false
      t.string :name, null: false
      t.citext :email, null: false
      t.integer :role, null: false, default: 2
      t.timestamp :last_login_at, null: false
      t.timestamp :last_seen_at, null: false
      t.timestamp :deleted_at
      t.string :github_username
      t.string :remember_token
      t.string :avatar_url
    end
    add_index :users, %i(github_username deleted_at), unique: true
    add_index :users, :email
  end
end
