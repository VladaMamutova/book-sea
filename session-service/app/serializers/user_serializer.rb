class UserSerializer < ActiveModel::Serializer
  attributes :user_uid, :login, :role
end
