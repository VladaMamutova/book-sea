class UserMonitoring < ApplicationRecord
  validates :user_uid, uniqueness: true
  validates :limit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
