class AddMiddleNameToAuthor < ActiveRecord::Migration[6.1]
  def change
    add_column :authors, :middle_name, :string
  end
end
