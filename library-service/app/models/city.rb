class City < ApplicationRecord
  has_many :libraries, dependent: :destroy
end
