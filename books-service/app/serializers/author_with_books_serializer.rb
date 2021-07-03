class AuthorWithBooksSerializer < ActiveModel::Serializer
  attributes :author_uid, :first_name, :middle_name, :last_name, :info

  has_many :books, serializer: BookSerializer
end
