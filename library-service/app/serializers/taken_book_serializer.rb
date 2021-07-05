class TakenBookSerializer < ActiveModel::Serializer
  attributes :taken_book_uid, :library_uid, :book_uid, :take_date
  attribute :return_date, if: :returned?
  attribute :status

  def take_date
    object.created_at.strftime('%F %T')
    # %F - The ISO 8601 date format (%Y-%m-%d)
    # %T - 24-hour time (%H:%M:%S)
  end

  def return_date
    object.updated_at.strftime('%F %T')
  end

  def returned?
    true if object.status != 'new'
  end
end
