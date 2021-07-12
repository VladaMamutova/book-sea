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

ActiveRecord::Schema.define(version: 20_210_712_023_330) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'taken_books', force: :cascade do |t|
    t.uuid 'taken_book_uid', null: false
    t.uuid 'user_uid', null: false
    t.uuid 'book_uid', null: false
    t.datetime 'take_date', precision: 6, null: false
    t.datetime 'return_date', precision: 6
    t.boolean 'in_time'
    t.integer 'status', null: false
    t.string 'book'
    t.string 'author'
    t.string 'genre'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
