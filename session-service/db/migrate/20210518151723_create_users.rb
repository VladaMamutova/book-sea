class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :login, null: false
      # The password field is called 'password_digest',
      # because this is a convention that the Bcrypt library
      # is looking for to know that it will be responsible
      # for digesting the password and encrypting it.
      t.string :password_digest, null: false
      t.uuid :user_uid, null: false

      t.timestamps
    end

    add_index :users, :login, unique: true
    add_index :users, :user_uid, unique: true
  end
end
