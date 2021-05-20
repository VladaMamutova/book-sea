class User < ApplicationRecord
  validates :login, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :user_uid, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :role, presence: true, inclusion: { in: %w[user admin] }

  enum role: %i[user admin]

  has_secure_password # from gem 'bcrypt'
end
