class AddLibraryRefToLibraryBooks < ActiveRecord::Migration[6.1]
  def change
    add_reference :library_books, :library, null: false, foreign_key: true
  end
end
