class Author < ApplicationRecord
  validates_with NameValidator
  validates :author_uid, presence: true

  has_many :books, dependent: :destroy, foreign_key: :author_uid, primary_key: :author_uid
end
