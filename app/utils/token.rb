module Token
  def encode(hash, expire=Time.now + 1.minute)
    JWT.encode(hash, secret, 'HS256')
  end

  private

  def secret
    @secret ||= ENV.fetch("TOKEN_SECRET", SecureRandom.alphanumeric(256))
  end
end