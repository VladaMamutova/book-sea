class Rating < ApplicationRecord
  validates :user_uid, uniqueness: true

  belongs_to :status
end
