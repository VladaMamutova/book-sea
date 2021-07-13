class TakenBook < ApplicationRecord
  validates :taken_book_uid, uniqueness: true
  validates :taken_book_uid, :user_uid, :book_uid, :take_date, :status, presence: true

  enum status: %i[new used bad_condition lost], _prefix: :status
  # add _prefix, because of the new is a keyword of Active Record method
end
