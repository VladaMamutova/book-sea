class TakenBookSerializer < ActiveModel::Serializer
  attributes :taken_book_uid, :book_uid, :date, :status

  def date
    object.created_at
  end
end
