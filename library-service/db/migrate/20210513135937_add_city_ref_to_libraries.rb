class AddCityRefToLibraries < ActiveRecord::Migration[6.1]
  def change
    add_reference :libraries, :city, null: false, foreign_key: true
  end
end
