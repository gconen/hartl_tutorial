class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 99}
    VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d.\-]+\.[a-z]+\Z/i
    validates :email, presence: true, length: {maximum: 254}, format: { with: VALID_EMAIL_REGEXP }, uniqueness: {case_sensitive: false}
    validates :password, length: {minimum: 6}
    has_secure_password
end
