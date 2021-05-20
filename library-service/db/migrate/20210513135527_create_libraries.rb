class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|
      t.string :name
      t.uuid :library_uid
      t.string :address

      t.timestamps
    end
  end
end
