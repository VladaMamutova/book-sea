class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.uuid :user_uid, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
