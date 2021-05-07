class AuthorShortSerializer < ActiveModel::Serializer
  attributes :first_name, :middle_name, :last_name
end
