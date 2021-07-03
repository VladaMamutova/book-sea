class CreateUserMonitorings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_monitorings do |t|
      t.uuid :user_uid, null: false
      t.uuid :taken_books, array: true, default: []
      t.integer :limit, null: false

      t.timestamps
    end
  end
end
