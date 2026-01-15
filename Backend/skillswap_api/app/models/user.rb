class User < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :requested_matches, class_name: "Match", foreign_key: "requester_id", dependent: :destroy
  has_many :provided_matches, class_name: "Match", foreign_key: "provider_id", dependent: :destroy
  
  has_secure_password

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: 2, maximum: 20 }

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: true,
            length: { minimum: 8 },
            on: :create
end
