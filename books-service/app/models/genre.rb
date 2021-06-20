class Genre < ApplicationRecord
  has_many :books, dependent: :destroy
end
