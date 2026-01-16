# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_16_093843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provider_id", null: false
    t.bigint "requester_id", null: false
    t.bigint "skill_id", null: false
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_matches_on_provider_id"
    t.index ["requester_id", "skill_id"], name: "index_matches_on_requester_id_and_skill_id", unique: true
    t.index ["requester_id"], name: "index_matches_on_requester_id"
    t.index ["skill_id"], name: "index_matches_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted"
    t.text "description"
    t.string "skill_type"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "matches", "skills"
  add_foreign_key "matches", "users", column: "provider_id"
  add_foreign_key "matches", "users", column: "requester_id"
  add_foreign_key "skills", "users"
end
