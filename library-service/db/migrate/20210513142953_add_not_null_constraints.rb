class AddNotNullConstraints < ActiveRecord::Migration[6.1]
  def change
    change_column_null :cities, :name, false
    change_column_null :libraries, :name, false
    change_column_null :libraries, :library_uid, false
    change_column_null :libraries, :address, false
  end
end
