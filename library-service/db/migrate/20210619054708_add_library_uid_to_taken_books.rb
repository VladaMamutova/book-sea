class AddLibraryUidToTakenBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :taken_books, :library_uid, :uuid, null: false
  end
end
