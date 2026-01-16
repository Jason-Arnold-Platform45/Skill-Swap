class UserSerializer
  include JSONAPI::Serializer

  set_type :user

  attributes :username, :email, :created_at

  has_many :skills
end
