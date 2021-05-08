class Book < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :book_uid, presence: true

  belongs_to :author, foreign_key: :author_uid, primary_key: :author_uid
  belongs_to :genre
end
