class TakenBookSerializer < ActiveModel::Serializer
  attributes :taken_book_uid, :user_uid, :book_uid, :take_date, :return_date, :in_time, :status, :book, :author, :genre
end
