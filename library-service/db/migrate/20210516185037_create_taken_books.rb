class CreateTakenBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :taken_books do |t|
      t.uuid :taken_book_uid, null: false
      t.uuid :book_uid, null: false
      t.uuid :user_uid, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
