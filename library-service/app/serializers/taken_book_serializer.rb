class TakenBookSerializer < ActiveModel::Serializer
  attributes :taken_book_uid, :library_uid, :book_uid, :take_date
  attribute :return_date, if: :returned?
  attribute :status

  def take_date
    object.created_at.strftime("%d.%m.%Y в %H:%M")
  end

  def return_date
    object.updated_at.strftime("%d.%m.%Y в %H:%M")
  end

  def returned?
    true if object.status != 'new'
  end
end
