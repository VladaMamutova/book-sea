class CreateTakenBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :taken_books do |t|
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

      t.timestamps
    end
  end
end
