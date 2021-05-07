class BookSerializer < ActiveModel::Serializer
  attributes :name, :genre

  belongs_to :author # using AuthorSerializer

  def genre
    object.genre.name
  end
end
