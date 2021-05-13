class AuthorSerializer < ActiveModel::Serializer
  attributes :first_name, :middle_name, :last_name, :info
end
