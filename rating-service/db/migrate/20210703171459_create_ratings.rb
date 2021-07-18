class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.uuid :user_uid, null: false
      t.integer :score, null: false
      t.belongs_to :status, foreign_key: true

      t.timestamps
    end
  end
end
