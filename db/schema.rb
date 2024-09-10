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

ActiveRecord::Schema[7.2].define(version: 2024_09_10_163132) do
  create_table "checklists", force: :cascade do |t|
    t.string "title"
    t.boolean "locked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.index ["owner_id"], name: "index_checklists_on_owner_id"
  end

  create_table "collaborations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "checklist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_collaborations_on_checklist_id"
    t.index ["user_id"], name: "index_collaborations_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.text "content"
    t.boolean "checked"
    t.integer "ordering"
    t.integer "checklist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_items_on_checklist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "checklists", "users", column: "owner_id"
  add_foreign_key "collaborations", "checklists"
  add_foreign_key "collaborations", "users"
  add_foreign_key "items", "checklists"
end
