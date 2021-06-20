class AuthorShortSerializer < ActiveModel::Serializer
  attributes :author_uid, :first_name, :middle_name, :last_name
end
