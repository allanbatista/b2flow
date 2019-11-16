class User < ApplicationRecord
  has_secure_password

  validates :password_digest, presence: true
  validates :email, presence: true, uniqueness: true

  def to_api
    as_json(only: [:id, :email, :created_at, :updated_at])
  end

  def to_token(expire_in=Time.now + 1.year)
    Token.encode({id: id.to_s}, expire_in)
  end

  def self.find_by_token(token)
    user = Token.decode(token)
    User.find(user["id"]) if user.present?
  end

  def self.find_and_authenticate(email, password)
    user = find_by(email: email)
    user if user.present? and user.authenticate(password)
  end
end
