class LibraryBookSerializer < ActiveModel::Serializer
  attributes :book_uid, :available_count # :library_uid

  # def library_uid
  #   object.library.library_uid
  # end
end
