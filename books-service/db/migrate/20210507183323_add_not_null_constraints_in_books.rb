class AddNotNullConstraintsInBooks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :books, :book_uid, false
    change_column_null :books, :name, false
  end
end
