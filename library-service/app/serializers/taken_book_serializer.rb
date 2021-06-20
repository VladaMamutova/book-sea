class TakenBookSerializer < ActiveModel::Serializer
  attributes :taken_book_uid, :library_uid, :book_uid, :date, :status

  def date
    object.created_at.strftime('%F %T')
    # %F - The ISO 8601 date format (%Y-%m-%d)
    # %T - 24-hour time (%H:%M:%S)
  end
end
