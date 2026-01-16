class MatchSerializer
  include JSONAPI::Serializer

  set_type :match

  attributes :status, :created_at

  belongs_to :skill
  belongs_to :requester, serializer: UserSerializer
  belongs_to :provider, serializer: UserSerializer
end
