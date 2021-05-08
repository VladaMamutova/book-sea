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

ActiveRecord::Schema.define(version: 20_210_508_081_101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'authors', force: :cascade do |t|
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.uuid 'author_uid', null: false
    t.string 'info'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'middle_name'
  end

  create_table 'books', force: :cascade do |t|
    t.string 'name', null: false
    t.uuid 'book_uid', null: false
    t.uuid 'libraries', default: [], array: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'genre_id', null: false
    t.uuid 'author_uid', null: false
    t.index ['author_uid'], name: 'index_books_on_author_uid'
    t.index ['genre_id'], name: 'index_books_on_genre_id'
  end

  create_table 'genres', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'books', 'genres'
end
