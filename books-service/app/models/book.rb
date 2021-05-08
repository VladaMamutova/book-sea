class Book < ApplicationRecord
  belongs_to :author, foreign_key: :author_uid, primary_key: :author_uid
  belongs_to :genre
end
