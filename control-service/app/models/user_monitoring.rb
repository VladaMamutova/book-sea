class UserMonitoring < ApplicationRecord
  validates :user_uid, uniqueness: true
end
