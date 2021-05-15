class LibrarySerializer < ActiveModel::Serializer
  attributes :name, :address, :city

  def city
    object.city.name
  end
end
