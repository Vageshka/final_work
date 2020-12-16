class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true,
                    length: { within: 5..20 }, format: { with: /\A[\w+.-]+\z/i }
  validates :password, length: { within: 6..20 }, format: { with: /\A\w*[A-Z]+\w*\z/ }

  has_secure_password
end
