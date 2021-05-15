class Library < ApplicationRecord
  belongs_to :city
  has_many :library_books, dependent: :destroy
end
