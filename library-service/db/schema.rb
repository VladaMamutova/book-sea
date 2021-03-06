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

ActiveRecord::Schema.define(version: 20_210_619_054_708) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'cities', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'libraries', force: :cascade do |t|
    t.string 'name', null: false
    t.uuid 'library_uid', null: false
    t.string 'address', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'city_id', null: false
    t.index ['city_id'], name: 'index_libraries_on_city_id'
  end

  create_table 'library_books', force: :cascade do |t|
    t.uuid 'book_uid', null: false
    t.integer 'available_count', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'library_id', null: false
    t.index ['library_id'], name: 'index_library_books_on_library_id'
  end

  create_table 'taken_books', force: :cascade do |t|
    t.uuid 'taken_book_uid', null: false
    t.uuid 'book_uid', null: false
    t.uuid 'user_uid', null: false
    t.integer 'status', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.uuid 'library_uid', null: false
  end

  add_foreign_key 'libraries', 'cities'
  add_foreign_key 'library_books', 'libraries'
end
