class JwtService
  def self.encode(user)
    Warden::JWTAuth::UserEncoder
      .new
      .call(user, :user, nil)
      .first
  end
end
