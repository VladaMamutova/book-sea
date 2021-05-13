class AddNotNullConstraintsInAuthors < ActiveRecord::Migration[6.1]
  def change
    change_column_null :authors, :author_uid, false
    change_column_null :authors, :first_name, false
    change_column_null :authors, :last_name, false
  end
end
