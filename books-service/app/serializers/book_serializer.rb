class BookSerializer < ActiveModel::Serializer
  attributes :book_uid, :name, :genre, :libraries

  belongs_to :author, serializer: AuthorShortSerializer

  def genre
    object.genre.name
  end
end
