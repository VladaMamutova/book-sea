class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, null: false
  end
end
