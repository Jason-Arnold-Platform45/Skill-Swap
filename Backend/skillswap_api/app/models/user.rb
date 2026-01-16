# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :skills, dependent: :destroy

  has_many :requested_matches,
           class_name: "Match",
           foreign_key: "requester_id",
           dependent: :destroy

  has_many :provided_matches,
           class_name: "Match",
           foreign_key: "provider_id",
           dependent: :destroy

  validates :username,
            presence: true,
            uniqueness: true,
            length: { minimum: 2, maximum: 20 }
end
