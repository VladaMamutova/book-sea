class Author < ApplicationRecord
  has_many :books, dependent: :destroy, foreign_key: :author_uid, primary_key: :author_uid
end
