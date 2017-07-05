class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: {message: "has been registered"}, presence: true
  validates :password, length: {minimum: 5}
  validates :password_confirmation, presence: true
end
