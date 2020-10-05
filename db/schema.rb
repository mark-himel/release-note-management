# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190808051849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "project_settings", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "git_repo_url"
    t.string "git_release_branch"
    t.string "git_webhook_url"
    t.citext "jira_username"
    t.string "encrypted_jira_api_token"
    t.string "encrypted_jira_api_token_iv"
    t.string "jira_site"
    t.string "jira_project_slug"
    t.string "git_repo_identifier"
    t.index ["project_id"], name: "index_project_settings_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name", null: false
    t.index ["team_id", "name"], name: "index_projects_on_team_id_and_name", unique: true
    t.index ["team_id"], name: "index_projects_on_team_id"
  end

  create_table "releases", force: :cascade do |t|
    t.string "pr_reference", null: false
    t.string "story_reference", null: false
    t.text "description", null: false
    t.date "date", null: false
    t.integer "state", default: 0, null: false
    t.bigint "project_id", null: false
    t.string "story_number", null: false
    t.string "pr_title", null: false
    t.string "pr_identifier", null: false
    t.bigint "user_id", null: false
    t.index ["date"], name: "index_releases_on_date"
    t.index ["project_id"], name: "index_releases_on_project_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "github_organization"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.string "name", null: false
    t.citext "email", null: false
    t.integer "role", default: 2, null: false
    t.datetime "last_login_at"
    t.datetime "last_seen_at"
    t.datetime "deleted_at"
    t.string "github_username"
    t.string "remember_token"
    t.string "avatar_url"
    t.string "encrypted_password", limit: 128
    t.string "email_confirmation_token", limit: 128
    t.datetime "email_confirmed_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["github_username", "deleted_at"], name: "index_users_on_github_username_and_deleted_at", unique: true
  end

  add_foreign_key "project_settings", "projects"
  add_foreign_key "projects", "teams"
  add_foreign_key "releases", "projects"
end
