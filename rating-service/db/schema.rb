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

ActiveRecord::Schema.define(version: 2021_07_03_171459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ratings", force: :cascade do |t|
    t.uuid "user_uid", null: false
    t.integer "score", null: false
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["status_id"], name: "index_ratings_on_status_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.integer "rank", null: false
    t.integer "limit", null: false
    t.integer "score", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "ratings", "statuses"
end
