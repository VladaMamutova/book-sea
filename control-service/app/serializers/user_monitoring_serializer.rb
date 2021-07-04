class UserMonitoringSerializer < ActiveModel::Serializer
  attributes :user_uid, :taken_books, :limit
end
