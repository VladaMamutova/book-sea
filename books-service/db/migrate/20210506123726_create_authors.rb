class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.uuid :author_uid
      t.string :info

      t.timestamps
    end
  end
end
