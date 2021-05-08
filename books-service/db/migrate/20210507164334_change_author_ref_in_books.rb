class ChangeAuthorRefInBooks < ActiveRecord::Migration[6.1]
  def up
    remove_column :books, :author_id
    add_column :books, :author_uid, :uuid, null: false
    add_index :books, :author_uid
  end

  def down
    remove_index :books, :author_uid
    remove_column :books, :author_uid
    add_column :books, :author_id, :bigint, null: false
  end
end
