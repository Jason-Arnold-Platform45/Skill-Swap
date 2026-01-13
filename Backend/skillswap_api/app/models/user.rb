class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 2, maximum: 20 }

  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, on: :create
end
