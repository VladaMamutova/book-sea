class LibraryBook < ApplicationRecord
  validates :book_uid, presence: true
  validates :available_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :library
end
