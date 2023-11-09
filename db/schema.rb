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

ActiveRecord::Schema[7.0].define(version: 2023_11_08_130320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cat_breeds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cat_breed_id", null: false
    t.string "name", null: false
    t.datetime "birthday"
    t.integer "gender", null: false
    t.string "avatar"
    t.text "self_introduction", default: "まだこの猫ちゃんの紹介については未記入だよ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cat_breed_id"], name: "index_cats_on_cat_breed_id"
    t.index ["user_id"], name: "index_cats_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "avatar"
    t.text "self_introduction"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cats", "cat_breeds"
  add_foreign_key "cats", "users"
end
