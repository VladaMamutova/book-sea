class LibrarySerializer < ActiveModel::Serializer
  attributes :library_uid, :name, :address, :city

  def city
    object.city.name
  end
end
