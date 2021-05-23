class LibraryBookWithLibrarySerializer < ActiveModel::Serializer
  attributes :library, :available_count

  belongs_to :library, serializer: LibrarySerializer
end
