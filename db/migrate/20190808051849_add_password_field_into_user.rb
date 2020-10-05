class AddPasswordFieldIntoUser < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :provider, true
    change_column_null :users, :uid, true
    change_column_null :users, :oauth_token, true
    change_column_null :users, :last_login_at, true
    change_column_null :users, :last_seen_at, true
    add_column :users, :encrypted_password, :string, limit: 128
    add_column :users, :email_confirmation_token, :string, limit: 128
    add_column :users, :email_confirmed_at, :datetime
  end
end
