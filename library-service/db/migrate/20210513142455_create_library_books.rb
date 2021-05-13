class CreateLibraryBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :library_books do |t|
      t.uuid :book_uid, null: false
      t.integer :available_count, null: false

      t.timestamps
    end
  end
end
