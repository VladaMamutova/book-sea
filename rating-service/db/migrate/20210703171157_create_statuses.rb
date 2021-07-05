class CreateStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :statuses do |t|
      t.integer :rank, null: false
      t.integer :limit, null: false
      t.integer :score, null: false

      t.timestamps
    end
  end
end
