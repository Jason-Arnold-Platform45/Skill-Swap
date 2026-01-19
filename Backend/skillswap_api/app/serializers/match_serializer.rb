class MatchSerializer
  include JSONAPI::Serializer

  attributes :status, :created_at

  belongs_to :skill
  belongs_to :requester, serializer: UserSerializer
  belongs_to :provider, serializer: UserSerializer
end
