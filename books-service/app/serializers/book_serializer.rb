class BookSerializer < ActiveModel::Serializer
  attributes :name, :genre

  belongs_to :author, serializer: AuthorShortSerializer

  def genre
    object.genre.name
  end
end
